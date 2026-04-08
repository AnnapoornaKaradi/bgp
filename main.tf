terraform {
	required_providers {
		azurerm = {
			version = "~> 4.27.0"
            
		}
	}
}
provider "azurerm" {
    subscription_id = var.subscriptions.subscriptionid
    tenant_id = var.subscriptions.tenantid
    features {}
}

    /*terraform {
	backend "azurerm" {
			subscription_id = "1a1ea867-a0f7-451d-b5b3-f3a276746beb"  
			tenant_id = "8a807b9b-02da-47f3-a903-791a42a2285c"
			resource_group_name = "FNF-RG-AKS-Nonprod"
			storage_account_name = "fnfsaaksnonproduse201"
			container_name = "terraform-state-aks-cluster"
			key = "fnf-lev-aks-nonprod-002.tfstate"
		}
	}*/
terraform {
        backend "azurerm" {
          use_azuread_auth     = true
    
    }
}

  
module "env_aks" {
    source = "../ccopinfra-modules/env_aks"
    basic = {
        region = var.basic.region
        region_short = var.basic.region_short
        envrnmt = var.basic.envrnmt
        env_short = var.basic.env_short
    }
    resource_group = {
        name =  var.resource_group.name
        location = var.resource_group.location
    }
    adgroups = {
        readergrp = var.adgroups.readergrp
        writergrp = var.adgroups.writergrp
        admingrp  = var.adgroups.admingrp
        podadmgrp = var.adgroups.podadmgrp
        pimadmingrp = var.adgroups.pimadmingrp
    }
    oidc_issuer_enabled = var.oidc_issuer_enabled
    workload_identity_enabled = var.workload_identity_enabled
    loadbalancer_sku = var.loadbalancer_sku 
    sku_tier = var.sku_tier
    outbound_type = var.outbound_type
    nodepool_subnet = var.nodepool_subnet
    vnet_name = var.vnet_name
    kubernetes_version = var.kubernetes_version
    aks_cluster_name = var.aks_cluster_name
    RG_id = var.RG_id
    default_node_pool_snet = var.default_node_pool_snet
    acr_list = var.acr_list
    analytics_ws_name = var.analytics_ws_name
    local_account_disabled =  var.local_account_disabled
    client_id = var.client_id
    image_cleaner_enabled = var.image_cleaner_enabled
    image_cleaner_interval_hours = var.image_cleaner_interval_hours
    key_vault = {
      name = var.key_vault.name
      resource_group = var.key_vault.resource_group
      secretname = var.key_vault.secretname
      subscription_id =  var.key_vault.subscription_id
    }
    subscriptions = {
		tenantid = var.subscriptions.tenantid
    }
    azure_rbac_enabled = var.azure_rbac_enabled
    network_rg = var.network_rg
    authorized_ip_ranges =  var.authorized_ip_ranges
    default_node_pool = {
        node_count = var.default_node_pool.node_count
        node_size = var.default_node_pool.node_size
        node_disk = var.default_node_pool.node_disk
        node_max_pods = var.default_node_pool.node_max_pods
        #address_prefix = ""
        auto_scaling_enabled = true
        min_count = var.default_node_pool.min_count
        max_count = var.default_node_pool.max_count
        labels = {}
    }
    
    additional_nodepools = {
        app = {
            node_count = var.additional_nodepools.node_count
            node_size = var.additional_nodepools.node_size
            node_disk = var.additional_nodepools.node_disk
            node_max_pods = var.additional_nodepools.node_max_pods
            orchestrator_version = var.kubernetes_version
            #address_prefix = ""
            os_type = "Linux"
            enable_auto_scaling = true
            node_pool_snet = var.additional_node_pool_snet
            min_count = var.additional_nodepools.min_count
            max_count = var.additional_nodepools.max_count
            taints = []            
            nodepool_node_os_label= "linux"
            nodepool_node_label =null
            # taints = [ "schedule=appdefault:NoSchedule" ]
            # labels = { "schedule" = "appdefault" }
        }
        # win = {
        #     node_count = 1
        #     node_size = "Standard_D8S_v5"
        #     node_disk = 160
        #     node_max_pods = var.additional_nodepools.node_max_pods
        #     #address_prefix = ""
        #     orchestrator_version = "1.24.10"
        #     os_type = "Windows"
        #     enable_auto_scaling = true
        #     node_pool_snet = var.windows_node_pool_snet
        #     min_count = 1
        #     max_count = 3
        #     taints = ["nodepooltype=fnfwin:NoSchedule"]            
        #     nodepool_node_os_label= "Win"
        #     nodepool_node_label = "fnfwin"
        #     # taints = [ "schedule=appdefault:NoSchedule" ]
        #     # labels = { "schedule" = "appdefault" }
        # }  
    }    
}
output "aks_cluster" {
    value = {        	
		host = module.env_aks.cluster.host		
		# client_certificate = module.env_aks.cluster.client_certificate
		# client_key = module.env_aks.cluster.client_key
		cluster_ca_certificate = module.env_aks.cluster.cluster_ca_certificate	
	
    }
    sensitive = true
}