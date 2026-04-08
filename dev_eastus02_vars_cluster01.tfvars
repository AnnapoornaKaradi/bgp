default_node_pool_snet = "/subscriptions/03f39f76-065e-46fd-a116-ba6085c71481/resourceGroups/FNF-RG-Networking-DevAndSandbox/providers/Microsoft.Network/virtualNetworks/vn-devandsandbox_AKS-use2-01/subnets/sn-10.151.34.0_24"
additional_node_pool_snet = "/subscriptions/03f39f76-065e-46fd-a116-ba6085c71481/resourceGroups/FNF-RG-Networking-DevAndSandbox/providers/Microsoft.Network/virtualNetworks/vn-devandsandbox_AKS-use2-01/subnets/sn-10.144.164.0_23"
windows_node_pool_snet = "/subscriptions/03f39f76-065e-46fd-a116-ba6085c71481/resourceGroups/FNF-RG-Networking-DevAndSandbox/providers/Microsoft.Network/virtualNetworks/vn-devandsandbox_AKS-use2-01/subnets/sn-10.144.166.0_23"
RG_id = "/subscriptions/03f39f76-065e-46fd-a116-ba6085c71481/resourceGroups/FNF-RG-AKS-Development"
aks_cluster_name = "fnf-lev-aks-dev-01"
kubernetes_version = "1.32.7"
sku_tier         = "Free"
oidc_issuer_enabled = true
workload_identity_enabled = true
vnet_name = "vn-devandsandbox_AKS-use2-01"
loadbalancer_sku = "standard"
outbound_type = "userDefinedRouting"
network_rg = "FNF-RG-Networking-DevAndSandbox"
local_account_disabled = true
client_id = "563ae20c-f1bb-4d71-b10b-c4a87b1e9af6"
image_cleaner_enabled = true
image_cleaner_interval_hours = 72
key_vault = {
      name = "kv-aks-dv"
      resource_group = "FNF-RG-AKS-Development"
      secretname = "devAksauthentication"
      subscription_id = "03f39f76-065e-46fd-a116-ba6085c71481"
    }
azure_rbac_enabled = true
basic = {
    region = "East US 2"
    region_short = "eus2"
    envrnmt = "Development"
    env_short = "dev"
}
default_node_pool = {
    node_count = 3
    node_size = "Standard_D8S_v5"
    node_disk = 160
    node_max_pods = 60
    min_count = 3
    max_count = 4
}
additional_nodepools = {
    node_count = 2
    node_size = "Standard_D8S_v5"
    node_disk = 160
    node_max_pods = 100
    min_count = 2
    max_count = 3
}

resource_group = {
	name = "fnf-rg-aks-development"
	location = "East US 2"
}
acr_list = ["CCOPaksACRdevAPP","CCOPaksACRdevPublicImages"]
analytics_ws_name = "fnf-aks-dev-use2-01"

adgroups = {
    readergrp = "34aef586-4148-4467-87aa-8137ccf02c50"
    writergrp = "ca4dad17-2a98-44e6-975d-2d93bb9440a8"
    admingrp = "689dc614-6bd5-4002-8d6f-3befae64b155"
    podadmgrp = "84a8b696-8813-42ef-8e41-c38ec2e7bc9f"
    pimadmingrp = "62dca759-8f4a-4ff9-9469-4ffef95f6815"
}
subscriptions = {	
    subscriptionid = "03f39f76-065e-46fd-a116-ba6085c71481"
    tenantid = "8a807b9b-02da-47f3-a903-791a42a2285c"

}
nodepool_subnet =["sn-10.151.34.0_24","sn-10.151.35.0_24","sn-10.144.164.0_23","sn-10.144.166.0_23"]
authorized_ip_ranges= ["20.41.38.144/32","172.177.219.21/32","40.84.6.79/32","115.114.81.229/32","182.74.242.26/32","14.99.185.242/32","170.88.0.0/16","52.167.252.29/32","52.254.39.161/32","172.177.156.49/32","20.36.237.153/32","20.36.237.154/32"]