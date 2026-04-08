resource "azurerm_storage_account" "functions" {
  name                     = "notesfunc${random_id.suffix.hex}"
  resource_group_name      = azurerm_resource_group.notes.name
  location                 = azurerm_resource_group.notes.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_service_plan" "notes" {
  name                = "notes-plan"
  resource_group_name = azurerm_resource_group.notes.name
  location            = azurerm_resource_group.notes.location
  os_type             = "Linux"
  sku_name            = "Y1"
}

resource "azurerm_linux_function_app" "notes" {
  name                       = "notes-func-${random_id.suffix.hex}"
  resource_group_name        = azurerm_resource_group.notes.name
  location                   = azurerm_resource_group.notes.location
  storage_account_name       = azurerm_storage_account.functions.name
  storage_account_access_key = azurerm_storage_account.functions.primary_access_key
  service_plan_id            = azurerm_service_plan.notes.id

  site_config {
    application_stack {
      python_version = "3.11"
    }
    cors {
      allowed_origins     = ["*"]
      support_credentials = false
    }
  }

  app_settings = {
    COSMOS_ENDPOINT              = azurerm_cosmosdb_account.notes.endpoint
    COSMOS_KEY                   = azurerm_cosmosdb_account.notes.primary_key
    COSMOS_DATABASE              = azurerm_cosmosdb_sql_database.notes.name
    COSMOS_CONTAINER             = azurerm_cosmosdb_sql_container.notes.name
    FUNCTIONS_WORKER_RUNTIME     = "python"
    AzureWebJobsFeatureFlags     = "EnableWorkerIndexing"
    WEBSITE_RUN_FROM_PACKAGE     = "1"
  }
}

data "archive_file" "function_code" {
  type        = "zip"
  source_dir  = "${path.module}/code"
  output_path = "${path.module}/function_code.zip"
}

resource "null_resource" "deploy_code" {
  depends_on = [azurerm_linux_function_app.notes]

  triggers = {
    code_hash = data.archive_file.function_code.output_sha256
  }

  provisioner "local-exec" {
    command = "az functionapp deployment source config-zip --name ${azurerm_linux_function_app.notes.name} --resource-group ${azurerm_resource_group.notes.name} --src ${data.archive_file.function_code.output_path}"
  }
}
