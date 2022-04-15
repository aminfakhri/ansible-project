output "db_server_name" {
  value = azurerm_postgresql_server.assignment-1-db_server.name
}

output "db_name" {
  value = azurerm_postgresql_database.assignment-1-db-postgre.name
}