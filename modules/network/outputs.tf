output "Vnet_name" {
  value = azurerm_virtual_network.assignment1-vnet.name
}

output "vnet_address_space" {
  value = azurerm_virtual_network.assignment1-vnet.address_space
}

output "subnet_name" {
  value = azurerm_subnet.assignment1-subnet.name
}

output "subnet_add_space" {
  value = azurerm_subnet.assignment1-subnet.address_prefixes
}

output "subnet_id" {
  value = azurerm_subnet.assignment1-subnet.id
}