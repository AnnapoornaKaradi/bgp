locals {
	aks_clustername = join("", [ "aks-", lower(var.basic.env_short), "-", lower(var.basic.region_short), "-01" ])
}
#----- Virtual Machine Contributor

resource "azurerm_role_assignment" "aks_sp_vm_contrib" {
	scope = data.azurerm_subscription.current.id
	role_definition_name = "Virtual Machine Contributor"
	principal_id = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
}

resource "azurerm_role_assignment" "aks_sp_appacr_role_assignment_acrpull" {
	count = length(var.acr_list)
    scope = data.azurerm_container_registry.acr[count.index].id
    role_definition_name = "AcrPull"
    principal_id = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
}
# resource "azurerm_role_assignment" "aks_sp_pubacr_role_assignment_acrpull" {
#     scope = data.azurerm_container_registry.acrpublic.id
#     role_definition_name = "AcrPull"
#     principal_id = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
# }

#----- Managed Identity Operator

resource "azurerm_role_assignment" "aks_sp_managed_identity_operator" {
	scope = data.azurerm_subscription.current.id
	role_definition_name = "Managed Identity Operator"
	principal_id = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id

}

#----- Monitoring Metrics Publisher

resource "azurerm_role_assignment" "aks_sp_metrics_role_assignment_mi" {
	scope = var.RG_id
	role_definition_name = "Monitoring Metrics Publisher"
	principal_id = azurerm_kubernetes_cluster.aks.oms_agent[0].oms_agent_identity[0].object_id

}

#-------- Network contributer 
resource "azurerm_role_assignment" "aks_sp_Contributer_role_assignment" {
	scope = var.RG_id
	role_definition_name = "Contributor"
	principal_id =  azurerm_kubernetes_cluster.aks.identity[0].principal_id

}

resource "azurerm_role_assignment" "aks_sp_Network_role_assignment" {
	count= length(var.nodepool_subnet)	
	scope = "${data.azurerm_subscription.current.id}/resourceGroups/${var.network_rg}/providers/Microsoft.Network/virtualNetworks/${var.vnet_name}/subnets/${var.nodepool_subnet[count.index]}"
	role_definition_name = "Network Contributor"
	principal_id =  azurerm_kubernetes_cluster.aks.identity[0].principal_id
}

#----- Create the Kubernetes cluster
    resource "azurerm_kubernetes_cluster" "aks" {
		name = var.aks_cluster_name
		resource_group_name = var.resource_group.name
		location = var.resource_group.location
		dns_prefix = local.aks_clustername
		kubernetes_version = var.kubernetes_version
		sku_tier = var.sku_tier
		role_based_access_control_enabled   = true
		azure_policy_enabled    = true
		oidc_issuer_enabled     = var.oidc_issuer_enabled
		workload_identity_enabled = var.workload_identity_enabled
		local_account_disabled = var.local_account_disabled
		api_server_access_profile {
	       authorized_ip_ranges = var.authorized_ip_ranges  
		}
		image_cleaner_enabled = var.image_cleaner_enabled
        image_cleaner_interval_hours = var.image_cleaner_interval_hours
		network_profile {
			network_plugin = "azure"
			network_policy = "azure"
            load_balancer_sku = var.loadbalancer_sku
			outbound_type = var.outbound_type
		}
		default_node_pool {
			name = "default"
			type = "VirtualMachineScaleSets"
			orchestrator_version = var.kubernetes_version
			
			node_labels = {
				"node.kubernetes.io/os" = "linux" ## For nonprod & prod
				
			}
			temporary_name_for_rotation = "systestnp"
			host_encryption_enabled = true
			node_count = var.default_node_pool.node_count
			vm_size = var.default_node_pool.node_size
			os_disk_size_gb = var.default_node_pool.node_disk
			max_pods = var.default_node_pool.node_max_pods			
			vnet_subnet_id 	= var.default_node_pool_snet
			node_public_ip_enabled = false
			auto_scaling_enabled = true
			min_count = var.default_node_pool.min_count
			max_count = var.default_node_pool.max_count
		}		
        oms_agent {
            log_analytics_workspace_id = data.azurerm_log_analytics_workspace.loganaylitcsws.id
    	}		
		identity {
			type = "SystemAssigned"
		}
		key_vault_secrets_provider {
		  secret_rotation_enabled = true
		}
		azure_active_directory_role_based_access_control {
			#managed  = true
			tenant_id = var.subscriptions.tenantid
			admin_group_object_ids = [var.adgroups.admingrp]
			azure_rbac_enabled = var.azure_rbac_enabled
		}
		tags = {
			environment = var.basic.envrnmt
		}
		
		lifecycle {
			ignore_changes = [ default_node_pool.0.node_count, tags ]
		}
    }


#----- Add additional node pools
resource "azurerm_kubernetes_cluster_node_pool" "additional_nodepool" {
		for_each = var.additional_nodepools
		#temporary_name_for_rotation = "apptest" 
		name = each.key	
		kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
		orchestrator_version = each.value.orchestrator_version
		os_type = each.value.os_type
		host_encryption_enabled = true
		node_count = each.value.node_count
		vm_size = each.value.node_size
		os_disk_size_gb = each.value.node_disk
		max_pods = each.value.node_max_pods
		node_labels = {
			"node.kubernetes.io/os" = each.value.nodepool_node_os_label
			"nodepooltype" = each.value.nodepool_node_label		
		}		
		vnet_subnet_id 	= each.value.node_pool_snet
		node_public_ip_enabled = false
		auto_scaling_enabled = true
		node_taints = each.value.taints
		min_count = each.value.min_count
		max_count = each.value.max_count
		tags = {
			environment = var.basic.envrnmt
		}
		lifecycle {
			ignore_changes = [ node_count ]
		}
}

# resource "azurerm_kubernetes_cluster_extension" "flux-ext" {
#   name           = "flux-ext"
#   cluster_id     = azurerm_kubernetes_cluster.aks.id
#   extension_type = "microsoft.flux"
# }
