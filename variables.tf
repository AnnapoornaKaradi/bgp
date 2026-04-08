variable "default_node_pool_snet" {
   type = string
}
variable "additional_node_pool_snet" {
   type = string
}
variable "windows_node_pool_snet" {
   type = string
}
variable "kubernetes_version" {
	type = string
}
variable "sku_tier" {
	type = string
}
variable "RG_id" {
   type = string
}
variable "aks_cluster_name" {
   type = string
}
variable "local_account_disabled" {
   type = bool
}
variable "client_id" {
  type = string
}
variable "key_vault" {
  type = object({
	name = string
	resource_group = string
	secretname = string
	subscription_id = string
  })
}
variable "azure_rbac_enabled" {
  type = bool
}
variable "basic" {
	type = object({
		region = string
		region_short = string
		envrnmt = string
		env_short = string
	})
}
variable "resource_group" {
	type = object({
		name = string
		location = string
	})
}
variable "acr_list" {
	type = list(string)
}
variable "analytics_ws_name" {
	type = string
}
variable "adgroups" {
	type = object({
		readergrp = string
		writergrp = string
		admingrp = string
		podadmgrp = string
		pimadmingrp = string
	})
}
variable "default_node_pool" {
	type = object({
		node_count = number
		node_size = string
		node_disk = number
		node_max_pods = number
		min_count = number
		max_count = number
	})
}
variable "additional_nodepools" {
	type = object({
		node_count = number
		node_size = string
		node_disk = number
		node_max_pods = number
		min_count = number
		max_count = number		
	})
}
variable "subscriptions" {
	type = object({
		subscriptionid = string
		tenantid = string
	})
}

variable "nodepool_subnet" {
	type = list(string)
}
variable "vnet_name" {
	type = string 
}
variable "loadbalancer_sku" {
	type = string
}
variable "outbound_type" {
	type = string
}
variable "network_rg" {
	type = string
}
variable "oidc_issuer_enabled" {
	type = bool  
}
variable "workload_identity_enabled" {
	type = bool
}
variable "authorized_ip_ranges" {
  type = list(string)
}
variable "image_cleaner_enabled" {
  type =  bool
}
variable "image_cleaner_interval_hours" {
  type = string
}