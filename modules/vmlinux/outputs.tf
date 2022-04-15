output "linux_vm_hostname" {
  value = values(azurerm_linux_virtual_machine.linux_vm)[*].name
}

output "linux_vm_id" {
  value = values(azurerm_linux_virtual_machine.linux_vm)[*].id
}


output "linux_Private_IP" {
  value = values(azurerm_linux_virtual_machine.linux_vm)[*].private_ip_address
}

output "linux_Public_IP" {
  
  value = values(azurerm_linux_virtual_machine.linux_vm)[*].public_ip_address
}

output "linux_nic" {
  value = values(azurerm_network_interface.linux_nic)[*]
}






