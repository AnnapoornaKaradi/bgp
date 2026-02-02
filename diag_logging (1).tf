locals {

storage_diag_subs = {
	queue = "/queueServices/default"
	blob = "/blobServices/default"
	file = "/fileServices/default"
	table = "/tableServices/default"
}


diag_logging_resource_types = {
	aks = "Microsoft.ContainerService/managedClusters"
	apim = "Microsoft.ApiManagement/service"
	app_config = "Microsoft.AppConfiguration/configurationStores"
	app_service_environments = "Microsoft.Web/hostingEnvironments"
	app_service_plans = "Microsoft.Web/serverfarms"
	az_sql = "Microsoft.Sql/servers"
	az_sql_db = "Microsoft.Sql/servers/databases"
	az_sql_elastic_pools = "Microsoft.Sql/servers/elasticPools"
	bastion = "Microsoft.Network/bastionHosts"
	cognitive_accounts = "Microsoft.CognitiveServices/accounts"
	cosmos = "Microsoft.DocumentDB/databaseAccounts"
	data_factory = "Microsoft.DataFactory/factories"
	event_grid_system_topic = "Microsoft.EventGrid/systemTopics"
	event_hub = "Microsoft.EventHub/namespaces"
	firewall = "Microsoft.Network/azureFirewalls"
	hbase = "Microsoft.HDInsight/clusters"
	key_vault = "Microsoft.KeyVault/vaults"
	load_balancer = "Microsoft.Network/loadBalancers"
	media_services = "Microsoft.Media/mediaservices"
	network_interface = "Microsoft.Network/networkInterfaces"
	notification_hub = "Microsoft.NotificationHubs/namespaces"
	nsg = "Microsoft.Network/networkSecurityGroups"
	powerbi = "Microsoft.PowerBIDedicated/capacities"
	public_ip = "Microsoft.Network/publicIPAddresses"
	recovery_services_vault = "Microsoft.RecoveryServices/vaults"
	redis = "Microsoft.Cache/Redis"
	service_bus = "Microsoft.ServiceBus/namespaces"
	signalr = "Microsoft.SignalRService/SignalR"
	storage_account = "Microsoft.Storage/storageAccounts"
	traffic_manager = "Microsoft.Network/trafficmanagerprofiles"
	vnet = "Microsoft.Network/virtualNetworks"
	wvd_app_group = "Microsoft.DesktopVirtualization/applicationgroups"
	wvd_host_pool = "Microsoft.DesktopVirtualization/hostpools"
	wvd_workspace = "Microsoft.DesktopVirtualization/workspaces"
}

loga_destination_type_az_diag = [
	"cosmos",
	"data_factory",
	"firewall",
	"recovery_services_vault",
]

diag_logging_loga_targets = {
	aks = {
		logs = [
			"kube-apiserver",
			"kube-controller-manager",
			"kube-scheduler",
			"cluster-autoscaler",
			"cloud-controller-manager",
			"guard",
			"csi-azuredisk-controller",
			"csi-azurefile-controller",
			"csi-snapshot-controller",
		]
		metrics = [ "*" ]
	}
	az_sql_db = {
		logs = [
			"SQLInsights",
			"AutomaticTuning",
			"QueryStoreRuntimeStatistics",
			"QueryStoreWaitStatistics",
			"Errors",
			"DatabaseWaitStatistics",
			"Timeouts",
			"Blocks",
			"Deadlocks",
		]
		metrics = [
			"Basic",
			"InstanceAndAppAdvanced",
			"WorkloadManagement",
		]
	}
	az_sql_elastic_pools = {
		metrics = [
			"Basic",
			"InstanceAndAppAdvanced",
		]
	}
	cosmos = {
		logs = [
			"QueryRuntimeStatistics",
			"PartitionKeyStatistics",
			"PartitionKeyRUConsumption",
			"ControlPlaneRequests",
		]
		metrics = [ "*" ]
	}
	data_factory = {
		logs = [
			"ActivityRuns",
			"PipelineRuns",
			"TriggerRuns",
			"SandboxPipelineRuns",
			"SandboxActivityRuns",
			"SSISPackageEventMessages",
			"SSISPackageExecutableStatistics",
			"SSISPackageEventMessageContext",
			"SSISPackageExecutionComponentPhases",
			"SSISPackageExecutionDataStatistics",
			"SSISIntegrationRuntimeLogs",
		]
		metrics = [ "*" ]
	}
	event_grid_system_topic = {
		logs = [
			"DeliveryFailures",
		]
	}
	event_hub = {
		logs = [
			"AutoScaleLogs",
			"OperationalLogs",
			"ApplicationMetricsLogs",
		]
		metrics = [ "*" ]
	}
	firewall = {
		logs = [ "*" ]
	}
	key_vault = {
		metrics = [ "*" ]
	}
	media_services = {
		logs = [ "*" ]
		metrics = [ "*" ]
	}
	network_interface = {
		metrics = [ "*" ]
	}
	recovery_services_vault = {
		logs = [
			"AzureBackupReport",
			"CoreAzureBackup",
			"AddonAzureBackupJobs",
			"AddonAzureBackupAlerts",
			"AddonAzureBackupPolicy",
			"AddonAzureBackupStorage",
			"AddonAzureBackupProtectedInstance",
			"AzureSiteRecoveryJobs",
			"AzureSiteRecoveryEvents",
			"AzureSiteRecoveryReplicatedItems",
			"AzureSiteRecoveryReplicationStats",
			"AzureSiteRecoveryRecoveryPoints",
			"AzureSiteRecoveryReplicationDataUploadRate",
			"AzureSiteRecoveryProtectedDiskDataChurn",
		]
		metrics = [ "Health" ]
	}
	redis = {
		metrics = [ "*" ]
	}
	service_bus = {
		logs = [
			"OperationalLogs",
			"ApplicationMetricsLogs",
			"DiagnosticErrorLogs"
		]
		metrics = [ "*" ]
	}
	vnet = {
		metrics = [ "*" ]
	}
}
	
diag_logging_storage_sub_loga_targets = {
	logs = [
		"StorageRead",
		"StorageWrite",
		"StorageDelete",
	]
}

}