2026-02-04T10:48:16.7489188Z An execution plan has been generated and is shown below.
2026-02-04T10:48:16.7490163Z Resource actions are indicated with the following symbols:
2026-02-04T10:48:16.7490684Z   [32m+[0m create
2026-02-04T10:48:16.7490883Z [0m
2026-02-04T10:48:16.7491081Z Terraform will perform the following actions:
2026-02-04T10:48:16.7491174Z 
2026-02-04T10:48:16.7943043Z [1m  # azurerm_monitor_diagnostic_setting.env_to_evh["_subscriptions_8d1a8329-ea90-46a3-b900-8676c42ed761_resourcegroups_rg-michaelguntherberg_providers_microsoft.network_virtualnetworks_vnet-eastus2"][0m will be created[0m[0m
2026-02-04T10:48:16.7943989Z [0m  [32m+[0m[0m resource "azurerm_monitor_diagnostic_setting" "env_to_evh" {
2026-02-04T10:48:16.7946618Z       [32m+[0m [0m[1m[0meventhub_authorization_rule_id[0m[0m = "/subscriptions/a2ca26b7-774e-4207-801a-c45151ff310d/resourceGroups/rg-log-common-eus2-01/providers/Microsoft.EventHub/namespaces/evh-diag-sandbox-eus2-01/authorizationRules/default_diagnostic_logging_rule"
2026-02-04T10:48:16.7948270Z       [32m+[0m [0m[1m[0meventhub_name[0m[0m                  = "evh-diag-sandbox-eus2-01"
2026-02-04T10:48:16.7949074Z       [32m+[0m [0m[1m[0mid[0m[0m                             = (known after apply)
2026-02-04T10:48:16.7952517Z       [32m+[0m [0m[1m[0mlog_analytics_destination_type[0m[0m = (known after apply)
2026-02-04T10:48:16.7955892Z       [32m+[0m [0m[1m[0mname[0m[0m                           = "to_event_hub"
2026-02-04T10:48:16.7959549Z       [32m+[0m [0m[1m[0mtarget_resource_id[0m[0m             = "/subscriptions/8d1a8329-ea90-46a3-b900-8676c42ed761/resourceGroups/rg-michaelguntherberg/providers/Microsoft.Network/virtualNetworks/vnet-eastus2"
2026-02-04T10:48:16.7960115Z 
2026-02-04T10:48:16.7962343Z       [32m+[0m [0menabled_log {
2026-02-04T10:48:16.7964787Z           [32m+[0m [0m[1m[0mcategory[0m[0m = "VMProtectionAlerts"
2026-02-04T10:48:16.7965126Z         }
2026-02-04T10:48:16.7965333Z 
2026-02-04T10:48:16.7965661Z       [32m+[0m [0mlog {
2026-02-04T10:48:16.7966193Z           [32m+[0m [0m[1m[0mcategory[0m[0m       = (known after apply)
2026-02-04T10:48:16.7966789Z           [32m+[0m [0m[1m[0mcategory_group[0m[0m = (known after apply)
2026-02-04T10:48:16.7967371Z           [32m+[0m [0m[1m[0menabled[0m[0m        = (known after apply)
2026-02-04T10:48:16.7967564Z 
2026-02-04T10:48:16.7967976Z           [32m+[0m [0mretention_policy {
2026-02-04T10:48:16.7972081Z               [32m+[0m [0m[1m[0mdays[0m[0m    = (known after apply)
2026-02-04T10:48:16.7974279Z               [32m+[0m [0m[1m[0menabled[0m[0m = (known after apply)
2026-02-04T10:48:16.7976637Z             }
2026-02-04T10:48:16.7976980Z         }
2026-02-04T10:48:16.7977117Z 
2026-02-04T10:48:16.7977574Z       [32m+[0m [0mmetric {
2026-02-04T10:48:16.7978101Z           [32m+[0m [0m[1m[0mcategory[0m[0m = "AllMetrics"
2026-02-04T10:48:16.7983558Z           [32m+[0m [0m[1m[0menabled[0m[0m  = false
2026-02-04T10:48:16.7989338Z         }
2026-02-04T10:48:16.7990356Z     }
2026-02-04T10:48:16.7990750Z 
2026-02-04T10:48:16.7992361Z [1m  # azurerm_monitor_diagnostic_setting.env_to_loga["_subscriptions_8d1a8329-ea90-46a3-b900-8676c42ed761_resourcegroups_rg-michaelguntherberg_providers_microsoft.network_virtualnetworks_vnet-eastus2"][0m will be created[0m[0m
2026-02-04T10:48:16.7996286Z [0m  [32m+[0m[0m resource "azurerm_monitor_diagnostic_setting" "env_to_loga" {
2026-02-04T10:48:16.7996965Z       [32m+[0m [0m[1m[0mid[0m[0m                             = (known after apply)
2026-02-04T10:48:16.7997587Z       [32m+[0m [0m[1m[0mlog_analytics_destination_type[0m[0m = (known after apply)
2026-02-04T10:48:16.8004897Z       [32m+[0m [0m[1m[0mlog_analytics_workspace_id[0m[0m     = "/subscriptions/a2ca26b7-774e-4207-801a-c45151ff310d/resourceGroups/rg-log-common-eus2-01/providers/Microsoft.OperationalInsights/workspaces/log-app-common-eus2-01"
2026-02-04T10:48:16.8005764Z       [32m+[0m [0m[1m[0mname[0m[0m                           = "to_log_analytics"
2026-02-04T10:48:16.8010720Z       [32m+[0m [0m[1m[0mtarget_resource_id[0m[0m             = "/subscriptions/8d1a8329-ea90-46a3-b900-8676c42ed761/resourceGroups/rg-michaelguntherberg/providers/Microsoft.Network/virtualNetworks/vnet-eastus2"
2026-02-04T10:48:16.8011077Z 
2026-02-04T10:48:16.8011538Z       [32m+[0m [0menabled_log {
2026-02-04T10:48:16.8012128Z           [32m+[0m [0m[1m[0mcategory[0m[0m       = (known after apply)
2026-02-04T10:48:16.8012870Z           [32m+[0m [0m[1m[0mcategory_group[0m[0m = (known after apply)
2026-02-04T10:48:16.8013056Z 
2026-02-04T10:48:16.8015167Z           [32m+[0m [0mretention_policy {
2026-02-04T10:48:16.8015707Z               [32m+[0m [0m[1m[0mdays[0m[0m    = (known after apply)
2026-02-04T10:48:16.8016790Z               [32m+[0m [0m[1m[0menabled[0m[0m = (known after apply)
2026-02-04T10:48:16.8017233Z             }
2026-02-04T10:48:16.8017543Z         }
2026-02-04T10:48:16.8017667Z 
2026-02-04T10:48:16.8018090Z       [32m+[0m [0mlog {
2026-02-04T10:48:16.8022057Z           [32m+[0m [0m[1m[0mcategory[0m[0m       = (known after apply)
2026-02-04T10:48:16.8024177Z           [32m+[0m [0m[1m[0mcategory_group[0m[0m = (known after apply)
2026-02-04T10:48:16.8024860Z           [32m+[0m [0m[1m[0menabled[0m[0m        = (known after apply)
2026-02-04T10:48:16.8025044Z 
2026-02-04T10:48:16.8025525Z           [32m+[0m [0mretention_policy {
2026-02-04T10:48:16.8026086Z               [32m+[0m [0m[1m[0mdays[0m[0m    = (known after apply)
2026-02-04T10:48:16.8026720Z               [32m+[0m [0m[1m[0menabled[0m[0m = (known after apply)
2026-02-04T10:48:16.8027105Z             }
2026-02-04T10:48:16.8027427Z         }
2026-02-04T10:48:16.8027725Z 
2026-02-04T10:48:16.8028144Z       [32m+[0m [0mmetric {
2026-02-04T10:48:16.8031528Z           [32m+[0m [0m[1m[0mcategory[0m[0m = "AllMetrics"
2026-02-04T10:48:16.8032326Z           [32m+[0m [0m[1m[0menabled[0m[0m  = true
2026-02-04T10:48:16.8034586Z         }
2026-02-04T10:48:16.8034917Z     }
2026-02-04T10:48:16.8035026Z 
2026-02-04T10:48:16.8036030Z [1m  # local_sensitive_file.az_sql_desired_state["app"][0m will be created[0m[0m
2026-02-04T10:48:16.8036573Z [0m  [32m+[0m[0m resource "local_sensitive_file" "az_sql_desired_state" {
2026-02-04T10:48:16.8037200Z       [32m+[0m [0m[1m[0mcontent[0m[0m              = (sensitive value)
2026-02-04T10:48:16.8037803Z       [32m+[0m [0m[1m[0mcontent_base64sha256[0m[0m = (known after apply)
2026-02-04T10:48:16.8038600Z       [32m+[0m [0m[1m[0mcontent_base64sha512[0m[0m = (known after apply)
2026-02-04T10:48:16.8039264Z       [32m+[0m [0m[1m[0mcontent_md5[0m[0m          = (known after apply)
2026-02-04T10:48:16.8039829Z       [32m+[0m [0m[1m[0mcontent_sha1[0m[0m         = (known after apply)
2026-02-04T10:48:16.8040636Z       [32m+[0m [0m[1m[0mcontent_sha256[0m[0m       = (known after apply)
2026-02-04T10:48:16.8042448Z       [32m+[0m [0m[1m[0mcontent_sha512[0m[0m       = (known after apply)
2026-02-04T10:48:16.8043422Z       [32m+[0m [0m[1m[0mdirectory_permission[0m[0m = "0700"
2026-02-04T10:48:16.8044025Z       [32m+[0m [0m[1m[0mfile_permission[0m[0m      = "0700"
2026-02-04T10:48:16.8044679Z       [32m+[0m [0m[1m[0mfilename[0m[0m             = (known after apply)
2026-02-04T10:48:16.8045315Z       [32m+[0m [0m[1m[0mid[0m[0m                   = (known after apply)
2026-02-04T10:48:16.8045711Z     }
2026-02-04T10:48:16.8045844Z 
2026-02-04T10:48:16.8046476Z [0m[1mPlan:[0m 3 to add, 0 to change, 0 to destroy.[0m
2026-02-04T10:48:16.8046891Z [0m
2026-02-04T10:48:16.8047354Z [1mChanges to Outputs:[0m
2026-02-04T10:48:16.8048152Z   [32m+[0m [0m[1m[0mai_foundry_eastus2_logs_evh_targets[0m[0m     = [
2026-02-04T10:48:16.8048775Z       [32m+[0m [0m[
2026-02-04T10:48:16.8049207Z           [32m+[0m [0m"Audit",
2026-02-04T10:48:16.8049691Z           [32m+[0m [0m"AzureOpenAIRequestUsage",
2026-02-04T10:48:16.8050144Z           [32m+[0m [0m"RequestResponse",
2026-02-04T10:48:16.8050574Z           [32m+[0m [0m"Trace",
2026-02-04T10:48:16.8050901Z         ],
2026-02-04T10:48:16.8051176Z     ]
2026-02-04T10:48:16.8053954Z   [32m+[0m [0m[1m[0mai_foundry_eastus2_logs_loga_targets[0m[0m    = [
2026-02-04T10:48:16.8054445Z       [32m+[0m [0m[],
2026-02-04T10:48:16.8054752Z     ]
2026-02-04T10:48:16.8055270Z   [32m+[0m [0m[1m[0mai_foundry_eastus2_metrics_evh_targets[0m[0m  = [
2026-02-04T10:48:16.8055738Z       [32m+[0m [0m[
2026-02-04T10:48:16.8056133Z           [32m+[0m [0m"AllMetrics",
2026-02-04T10:48:16.8056444Z         ],
2026-02-04T10:48:16.8056743Z     ]
2026-02-04T10:48:16.8057298Z   [32m+[0m [0m[1m[0mai_foundry_eastus2_metrics_loga_targets[0m[0m = [
2026-02-04T10:48:16.8057755Z       [32m+[0m [0m[],
2026-02-04T10:48:16.8058086Z     ][0m
2026-02-04T10:48:16.8058212Z 
