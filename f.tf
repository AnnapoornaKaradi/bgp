diag_logging_loga_targets = {
	cognitive_accounts = {
		per_resource = {
			"ai-foundry-eastus2" = {
				# All logs except 'Audit' for Log Analytics
				logs = [
					"RequestResponse",
					"AzureOpenAIRequestUsage",
					"Trace"
				]
				metrics = [ "*" ]
			}
		}
	}
