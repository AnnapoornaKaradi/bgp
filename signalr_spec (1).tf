locals {

signalr_instances = {
	app = {
		name = "app"
		numeric = "1"
		rg_ref = "data"
		size = {
			default = {
				sku = "Standard_S1"
				capacity = 1
			}
			env_override = {
				perf = {
					sku = "Standard_S1"
					capacity = 2
				}
			}
			mg_override = {
				prod = {
					sku = "Standard_S1"
					capacity = 20
				}
			}
		}
		injections = {
			primary_connection_string = {
				attr = "primary_connection_string"
				kv_name = "ExosMacro--SignalR--ConnectionString"
				kv_ref = "app"
				app_config_name = "ExosMacro:SignalR:ConnectionString"
				app_config_ref = "app"
			}
			secondary_connection_string = {
				attr = "secondary_connection_string"
				kv_name = "ExosMacro--SignalR--ConnectionStringSecondary"
				kv_ref = "app"
				app_config_name = "ExosMacro:SignalR:ConnectionStringSecondary"
				app_config_ref = "app"
			}
		}
		cors_allowed_origins = compact(concat(
			[
				"http://localhost",
				"https://localhost",
				"http://localhost:4200",
				"https://localhost:4200",
				"http://localhost:4500",
				"https://localhost:4500",
				"http://localhost:13222",
				"http://localhost:28120",
				"http://localhost:12344",
				"http://127.0.0.1:13222",
				"http://127.0.0.1:28120",
				"http://127.0.0.1:12344",
				"https://.exostechnology.com",
				"https://.exostechnology.com:4200",
				"https://ui.${local.my_env_short}.exostechnology.com",
				(local.i_am_geo ? "https://ui.${local.my_env_short}${local.regions[local.site_type].name_friendly}.exostechnology.com" : ""),
			],
			# Add servicer and provider endpoints
			flatten(
				[ for servicer, provider in local.servicer_instances :
					[ for domain in var.nginx_edge_external_domain_names :
						"https://${servicer}.${domain}"
					]
				]
			),
			# Add Hudson and Marshall if its enabled in Nginx
			(var.nginx_edge_enable_hudsonandmarshall ?
				[
					"https://.hudsonandmarshall.com",
					"https://www.hudsonandmarshall.com",
				] : []
			),
			# Add hostnames specific to only Production
			(local.my_env_short == "prod" ?
				[ 
					"https://ui.exostechnology.com",
					"https://ui${local.regions[local.site_type].name_friendly}.exostechnology.com",
					"https://.servicelinkauction.com",
					"https://www.servicelinkauction.com",
				] : []
			),
		))
	}
}

}
