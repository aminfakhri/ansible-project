output "windows_VM_Hostname" {
  value = azurerm_windows_virtual_machine.windows_vm.computer_name
}

output "windows_Private_IP" {
  value = azurerm_windows_virtual_machine.windows_vm.private_ip_address

}

output "windows_Public_IP" {
  value = azurerm_windows_virtual_machine.windows_vm.public_ip_address

}

output "Windows_VM_Id" {
  value = azurerm_windows_virtual_machine.windows_vm.id
}

output "Windows_vm_nic" {
  value = azurerm_network_interface.windows_nic
}