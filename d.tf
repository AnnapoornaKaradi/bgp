# Diagnostic logging is coded as a catch-all since some PaaS offerings build resources which Terraform is unaware of.
# It is assumed that this step creates no new resources which need diagnostic logging, therefore it will catch everything the first run.
# If that isn't the case, it will still work, however it will require multiple runs to catch everything (which is not recommended).

locals {

  diag_settings_iterator = local.site_type == "primary" ? {
    for k, v in flatten([
      for type_key, type_name in local.diag_logging_resource_types : [
        for resource_value in data.azurerm_resources.diag[type_key].resources : {

          type_key      = type_key
          resource_name = resource_value.name
          resource_id   = resource_value.id

          # Detect the region this should be pinned to (default to primary)
          region_short_name = length([
            for _, r in local.regions :
            r.name_short if resource_value.location == lower(replace(r.name, " ", ""))
          ]) == 0
          ? local.regions.primary.name_short
          : [
              for _, r in local.regions :
              r.name_short if resource_value.location == lower(replace(r.name, " ", ""))
            ][0]

          region_mismatch = length([
            for _, r in local.regions :
            r.name_short if resource_value.location == lower(replace(r.name, " ", ""))
          ]) == 0

          # Generic per-resource override check
          has_per_resource_override = contains(
            keys(
              lookup(
                lookup(local.diag_logging_loga_targets, type_key, {}),
                "per_resource",
                {}
              )
            ),
            resource_value.name
          )

          # ---------------------------
          # Log Analytics targets
          # ---------------------------
          logs_loga_targets = has_per_resource_override
            ? [
                for k, v in data.azurerm_monitor_diagnostic_categories.env[type_key].logs : v
                if k != "Audit"
              ]
            : [
                for k, v in data.azurerm_monitor_diagnostic_categories.env[type_key].logs : v
                if contains(lookup(lookup(local.diag_logging_loga_targets, type_key, {}), "logs", []), k)
                || contains(lookup(lookup(local.diag_logging_loga_targets, type_key, {}), "logs", []), "*")
                || region_mismatch
              ]

          metrics_loga_targets = [
            for k, v in data.azurerm_monitor_diagnostic_categories.env[type_key].metrics : v
            if contains(lookup(lookup(local.diag_logging_loga_targets, type_key, {}), "metrics", []), k)
            || contains(lookup(lookup(local.diag_logging_loga_targets, type_key, {}), "metrics", []), "*")
            || region_mismatch
          ]

          # ---------------------------
          # Event Hub targets
          # ---------------------------
          logs_evh_targets = has_per_resource_override
            ? ["Audit"]
            : [
                for k, v in data.azurerm_monitor_diagnostic_categories.env[type_key].logs : v
                if !contains(lookup(lookup(local.diag_logging_loga_targets, type_key, {}), "logs", []), k)
                && !contains(lookup(lookup(local.diag_logging_loga_targets, type_key, {}), "logs", []), "*")
                && !region_mismatch
              ]

          metrics_evh_targets = has_per_resource_override
            ? []
            : [
                for k, v in data.azurerm_monitor_diagnostic_categories.env[type_key].metrics : v
                if !contains(lookup(lookup(local.diag_logging_loga_targets, type_key, {}), "metrics", []), k)
                && !contains(lookup(lookup(local.diag_logging_loga_targets, type_key, {}), "metrics", []), "*")
                && !region_mismatch
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
  } : {}

}
