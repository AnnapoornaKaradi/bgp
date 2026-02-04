# Diagnostic logging is coded as a catch-all since some PaaS offerings build resources which Terraform is unaware of.
# It is assumed that this step creates no new resources which need diagnostic logging, therefore it will catch everything the first run
# If that isn't the case, it will still work, however it will require multiple runs to catch everything (which is not recommended)

locals {

  ############################################
  # MAIN DIAGNOSTIC SETTINGS ITERATOR
  ############################################

  diag_settings_iterator = local.site_type == "primary" ? ({
    for k, v in flatten([
      for type_key, type_name in local.diag_logging_resource_types : [
        for resource_key, resource_value in data.azurerm_resources.diag[type_key].resources : {

          type_key      = type_key
          resource_name = resource_value.name
          resource_id   = resource_value.id

          # Detect the region this should be pinned to based on the resources location with the default being primary.
          region_short_name = length([
            for k, v in local.regions :
            v.name_short
            if resource_value.location == lower(replace(v.name, " ", ""))
          ]) == 0 ? local.regions.primary.name_short : [
            for k, v in local.regions :
            v.name_short
            if resource_value.location == lower(replace(v.name, " ", ""))
          ][0]

          region_mismatch = length([
            for k, v in local.regions :
            v.name_short
            if resource_value.location == lower(replace(v.name, " ", ""))
          ]) == 0

          # Per-resource override detection (generic)
          is_per_resource_override = contains(
            keys(
              lookup(
                lookup(local.diag_logging_loga_targets, type_key, {}),
                "per_resource",
                {}
              )
            ),
            resource_value.name
          )

          ############################################
          # LOG ANALYTICS TARGETS
          ############################################

          logs_loga_targets = is_per_resource_override ? [
            for k, v in data.azurerm_monitor_diagnostic_categories.env[type_key].logs : v
            if k != "Audit"
          ] : [
            for k, v in data.azurerm_monitor_diagnostic_categories.env[type_key].logs : v
            if contains(
              lookup(lookup(local.diag_logging_loga_targets, type_key, {}), "logs", []),
              k
            )
            || contains(
              lookup(lookup(local.diag_logging_loga_targets, type_key, {}), "logs", []),
              "*"
            )
            || length([
              for k, v in local.regions :
              v.name_short
              if resource_value.location == lower(replace(v.name, " ", ""))
            ]) == 0
          ]

          metrics_loga_targets = [
            for k, v in data.azurerm_monitor_diagnostic_categories.env[type_key].metrics : v
            if contains(
              lookup(lookup(local.diag_logging_loga_targets, type_key, {}), "metrics", []),
              k
            )
            || contains(
              lookup(lookup(local.diag_logging_loga_targets, type_key, {}), "metrics", []),
              "*"
            )
            || length([
              for k, v in local.regions :
              v.name_short
              if resource_value.location == lower(replace(v.name, " ", ""))
            ]) == 0
          ]

          ############################################
          # EVENT HUB TARGETS
          ############################################

          logs_evh_targets = is_per_resource_override ? [
            "Audit"
          ] : [
            for k, v in data.azurerm_monitor_diagnostic_categories.env[type_key].logs : v
            if !contains(
              lookup(lookup(local.diag_logging_loga_targets, type_key, {}), "logs", []),
              k
            )
            && !contains(
              lookup(lookup(local.diag_logging_loga_targets, type_key, {}), "logs", []),
              "*"
            )
            && length([
              for k, v in local.regions :
              v.name_short
              if resource_value.location == lower(replace(v.name, " ", ""))
            ]) != 0
          ]

          metrics_evh_targets = is_per_resource_override ? [] : [
            for k, v in data.azurerm_monitor_diagnostic_categories.env[type_key].metrics : v
            if !contains(
              lookup(lookup(local.diag_logging_loga_targets, type_key, {}), "metrics", []),
              k
            )
            && !contains(
              lookup(lookup(local.diag_logging_loga_targets, type_key, {}), "metrics", []),
              "*"
            )
            && length([
              for k, v in local.regions :
              v.name_short
              if resource_value.location == lower(replace(v.name, " ", ""))
            ]) != 0
          ]
        }
        if !contains(
          lookup(local.my_env, "diag_logging_excluded_resource_groups", []),
          resource_value.resource_group_name
        )
      ]
    ]) :
    lower(replace(v.resource_id, "/", "_")) => v
    if length(regexall("/databases/master", v.resource_id)) == 0
  }) : {}

}

############################################
# RESOURCE DISCOVERY
############################################

data "azurerm_resources" "diag" {
  for_each = local.diag_logging_resource_types
  type     = each.value
}

data "azurerm_monitor_diagnostic_categories" "env" {
  for_each = local.site_type == "primary"
    ? { for k, v in data.azurerm_resources.diag : k => v if length(v.resources) > 0 }
    : {}

  resource_id = each.value.resources[0].id
}

############################################
# LOG ANALYTICS DIAGNOSTIC SETTINGS
############################################

resource "azurerm_monitor_diagnostic_setting" "env_to_loga" {
  for_each = {
    for k, v in local.diag_settings_iterator :
    k => v if length(v.logs_loga_targets) != 0 || length(v.metrics_loga_targets) != 0
  }

  name               = "to_log_analytics"
  target_resource_id = each.value.resource_id

  log_analytics_workspace_id = data.terraform_remote_state.common.outputs.log_analytics["default"].id
  log_analytics_destination_type = contains(
    local.loga_destination_type_az_diag,
    each.value.type_key
  ) ? "AzureDiagnostics" : null

  dynamic "enabled_log" {
    for_each = {
      for k, v in data.azurerm_monitor_diagnostic_categories.env[each.value.type_key].logs :
      k => v if contains(each.value.logs_loga_targets, v)
    }
    content {
      category = enabled_log.value
    }
  }

  dynamic "metric" {
    for_each = data.azurerm_monitor_diagnostic_categories.env[each.value.type_key].metrics
    content {
      category = metric.value
      enabled  = contains(each.value.metrics_loga_targets, metric.value)
    }
  }
}

############################################
# EVENT HUB DIAGNOSTIC SETTINGS
############################################

resource "azurerm_monitor_diagnostic_setting" "env_to_evh" {
  for_each = {
    for k, v in local.diag_settings_iterator :
    k => v if length(v.logs_evh_targets) != 0 || length(v.metrics_evh_targets) != 0
  }

  name               = "to_event_hub"
  target_resource_id = each.value.resource_id

  eventhub_name = data.terraform_remote_state.common.outputs.event_hub_diag_logging[
    "${local.basic["local"].env_short}_${each.value.region_short_name}"
  ].name

  eventhub_authorization_rule_id = data.terraform_remote_state.common.outputs.event_hub_diag_logging[
    "${local.basic["local"].env_short}_${each.value.region_short_name}"
  ].diag_logging_auth_rule_id

  dynamic "enabled_log" {
    for_each = {
      for k, v in data.azurerm_monitor_diagnostic_categories.env[each.value.type_key].logs :
      k => v if contains(each.value.logs_evh_targets, v)
    }
    content {
      category = enabled_log.value
    }
  }

  dynamic "metric" {
    for_each = data.azurerm_monitor_diagnostic_categories.env[each.value.type_key].metrics
    content {
      category = metric.value
      enabled  = contains(each.value.metrics_evh_targets, metric.value)
    }
  }

  lifecycle {
    ignore_changes = [log_analytics_destination_type]
  }
}
