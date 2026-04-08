terraform {
	required_providers {
		azurerm = {
			#source = "hashicorp/azurerm" 
			version = "~> 4.27.0"
		}
		helm = {
			#source = "hashicorp/helm"
			version = "< 2.5.1"
		}
		tls= {
			#source = "hashicorp/tls"
			version = "3.4.0"
		}
		kubernetes= {
			#source = "hashicorp/kubernetes"
			version = "~> 2.11.0"
		}
		azuread = {
			source  = "hashicorp/azuread"
			version = "2.38.0"
    }
		
	}
}
# terraform {

#     required_providers {
#         azurerm  = "~> 4.27.0"
#         helm =  "< 2.5.1"
#         tls= "3.4.0"
#         kubernetes= "~> 2.11.0"
#         azuread = "2.38.0"      
#     }
# }
provider "azurerm" {
    subscription_id = var.key_vault.subscription_id
    #resource_provider_registration {
   #   skip = true
	#} 
    features {}
    alias = "management"
}
provider "kubernetes" {
  host                   = azurerm_kubernetes_cluster.aks.kube_config.0.host
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)

  # Using kubelogin to get an AAD token for the cluster.
  exec {
    api_version = "client.authentication.k8s.io/v1"
    command     = "kubelogin"
    args = [
      "get-token",
      "--environment",
      "AzurePublicCloud",
      "--server-id",
      "6dae42f8-4368-4678-94ff-3960e28e3630", # Application Id of the Azure Kubernetes Service AAD Server.
       "--client-id",
       var.client_id, # client id of SPN for authenticating  aks cluster
       "--client-secret",
       data.azurerm_key_vault_secret.key_vault_secret.value,
      "-t",
      var.subscriptions.tenantid, // The AAD Tenant Id.
      "-l",
      "spn" // Login using a Service Principal..
    ]
  }
}
provider "helm" {
    kubernetes {
 		 host                   = azurerm_kubernetes_cluster.aks.kube_config.0.host
  		cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)

  		# Using kubelogin to get an AAD token for the cluster.
  		exec {
   			 api_version = "client.authentication.k8s.io/v1"
    		command     = "kubelogin"
    		args = [
      			"get-token",
    	  		"--environment",
    			"AzurePublicCloud",
      			"--server-id",
      			"6dae42f8-4368-4678-94ff-3960e28e3630", # Application Id of the Azure Kubernetes Service AAD Server.
       			"--client-id",
       			var.client_id, # client id of SPN for authenticating  aks cluster to deploy helm charts.
       			"--client-secret",
       			data.azurerm_key_vault_secret.key_vault_secret.value,
      			"-t",
      			var.subscriptions.tenantid, // The AAD Tenant Id.
      			"-l",
      			"spn" // Login using a Service Principal..
    		]
  		}
	}
}
provider "azuread" {}
provider "tls" {}