locals {

signalr_outputs = { for k, v in local.signalr_instances :
	k => {
		primary_connection_string = local.credentials_rotating ? lookup(data.azurerm_signalr_service.injections, k, { primary_connection_string = "dummy" }).primary_connection_string : azurerm_signalr_service.env[k].primary_connection_string
		secondary_connection_string = local.credentials_rotating ? lookup(data.azurerm_signalr_service.injections, k, { secondary_connection_string = "dummy" }).secondary_connection_string : azurerm_signalr_service.env[k].secondary_connection_string
	}	
}

signalr_injections_iterator = { for k, v in flatten(
	[ for instance_key, instance_value in local.signalr_instances :
		[ for inject_key, inject_value in lookup(instance_value, "injections", {}) :
			{
				instance_key = instance_key
				inject_key = inject_key
				inject_value = inject_value
				use_kv = contains(keys(inject_value), "kv_name")
				use_app_config = contains(keys(inject_value), "app_config_name")
			}
		]
	]
) : "signalr_${v.instance_key}_${v.inject_key}" => v }

signalr_injections = { for k, v in local.signalr_injections_iterator :
	k => {
		kv_name = lookup(v.inject_value, "kv_name", null)
		kv_ref = lookup(v.inject_value, "kv_ref", null)
		kv_value = v.use_kv ? local.signalr_outputs[v.instance_key][v.inject_value.attr] : null
		app_config_name = lookup(v.inject_value, "app_config_name", null)
		app_config_ref = lookup(v.inject_value, "app_config_ref", null)
		# If app config is specified, assume precense of kv_name means itll be a key vault reference, otherwise its a direct injection
		app_config_value = v.use_app_config ? (v.use_kv ? "kv_ref" : local.signalr_outputs[v.instance_key][v.inject_value.attr]) : null
	}
}
	
}

#----- Create the SignalR instance
resource "azurerm_signalr_service" "env" {
	for_each = local.signalr_instances
	
	name = lower("signalr-${each.value.name}-${local.basic["local"].env_short}-${local.basic["local"].region_short}-${each.value.numeric}")
	resource_group_name = data.terraform_remote_state.baseinfra_00["local"].outputs.resource_groups[each.value.rg_ref].name
	location = data.terraform_remote_state.baseinfra_00["local"].outputs.resource_groups[each.value.rg_ref].location
	
	sku {
		name = (
			lookup(lookup(local.signalr_instances["app"].size, "env_override", {}), local.basic["local"].env_short, null) != null ? each.value.size.env_override[local.basic["local"].env_short].sku :
			lookup(lookup(local.signalr_instances["app"].size, "mg_override", {}), local.my_mg_ref, null) != null ? each.value.size.mg_override[local.my_mg_ref].sku :
			each.value.size.default.sku
		)
		capacity = (
			lookup(lookup(local.signalr_instances["app"].size, "env_override", {}), local.basic["local"].env_short, null) != null ? each.value.size.env_override[local.basic["local"].env_short].capacity :
			lookup(lookup(local.signalr_instances["app"].size, "mg_override", {}), local.my_mg_ref, null) != null ? each.value.size.mg_override[local.my_mg_ref].capacity :
			each.value.size.default.capacity
		)
	}
	
	cors {
		allowed_origins = each.value.cors_allowed_origins
	}
	
	service_mode = "Default"
	
	tags = local.tags
	lifecycle {
		ignore_changes = [
			tags,
		]
	}
}

#----- Rotate the SignalR connection keys
resource "null_resource" "signalr_connection_key_rotation" {
	for_each = local.signalr_instances
	
	triggers = {
		credentials_keeper = local.my_env.keepers.credentials
	}
	
	provisioner "local-exec" {
		command = <<EOT
			/usr/bin/az signalr key renew --key-type primary --name $NAME --resource-group $RG_NAME > /dev/null || exit 1;
			
			elapsed_time=0;
			
			while [ "`/usr/bin/az signalr show --name $NAME --resource-group $RG_NAME | jq -r .provisioningState`" != "Succeeded" ]; do
				sleep 5;
				
				elapsed_time=$((elapsed_time + 5));
				
				if [ $elapsed_time -ge 1200 ]; then
					echo "Timeout reached waiting for provider registration.";
					exit 1;
				fi
			done
			
			/usr/bin/az signalr key renew --key-type secondary --name $NAME --resource-group $RG_NAME > /dev/null || exit 1;
		EOT
		
		environment = {
			NAME = azurerm_signalr_service.env[each.key].name
			RG_NAME = azurerm_signalr_service.env[each.key].resource_group_name
		}
	}
	
	depends_on = [ azurerm_signalr_service.env ]
}

data "azurerm_signalr_service" "injections" {
	for_each = local.signalr_instances
	
	name = azurerm_signalr_service.env[each.key].name
	resource_group_name = azurerm_signalr_service.env[each.key].resource_group_name
	
	depends_on = [ null_resource.signalr_connection_key_rotation ]
}