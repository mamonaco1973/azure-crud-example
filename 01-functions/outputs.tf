output "function_app_name" {
  value = azurerm_linux_function_app.notes.name
}

output "function_app_url" {
  value = "https://${azurerm_linux_function_app.notes.default_hostname}/api"
}

output "resource_group_name" {
  value = azurerm_resource_group.notes.name
}
