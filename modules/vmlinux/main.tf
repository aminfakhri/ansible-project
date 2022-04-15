resource "azurerm_availability_set" "linux_avs" {
  name                = var.linux_availability_set
  location            = var.location
  resource_group_name = var.rg_name
  platform_fault_domain_count  = 2
  platform_update_domain_count = 5
}

resource "azurerm_public_ip" "linux_pip" {
  for_each            = var.linux_name
  name                = "${each.key}-pip"
  resource_group_name = var.rg_name
  location            = var.location
  allocation_method   = "Static"
  tags                = var.tags
  domain_name_label   = each.key
}

resource "azurerm_network_interface" "linux_nic" {
  for_each            = var.linux_name
  name                = "${each.key}-nic"
  location            = var.location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "${each.key}-nic-ip"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.linux_pip[each.key].id
 }
 tags         = var.tags
  depends_on = [
    azurerm_public_ip.linux_pip
  ]
}

resource "azurerm_linux_virtual_machine" "linux_vm" {
  for_each            = var.linux_name
  name                = each.key
  computer_name       = each.key
  resource_group_name = var.rg_name
  availability_set_id = azurerm_availability_set.linux_avs.id
  location            = var.location
  size                = var.linux_vm_size
  admin_username      = var.vm_admin_user
  network_interface_ids = [azurerm_network_interface.linux_nic[each.key].id]
  allow_extension_operations = true

  admin_ssh_key {
    username   = var.vm_admin_user
    public_key = file(var.linux_admin_ssh_key.public_key)
  }

  os_disk {
    caching              = var.linux_os_disk_attr.os_caching
    storage_account_type = var.linux_os_disk_attr.os_storage_Account_type
    disk_size_gb         = 32
  }

  source_image_reference {
    publisher = var.linux_os_disk_info.os_publisher
    offer     = var.linux_os_disk_info.os_offer
    sku       = var.linux_os_disk_info.os_sku
    version   = var.linux_os_disk_info.os_version
  }
  boot_diagnostics {
    storage_account_uri = var.storage_account_uri
  }
  tags = var.tags
}

resource "azurerm_managed_disk" "assignment1-disk-linux" {
  for_each            = var.linux_name
  name                 = "${each.key}-datadisk"
  location             = var.location
  resource_group_name  = var.rg_name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 30
  tags = var.tags
}

resource "azurerm_virtual_machine_data_disk_attachment" "assignment1-attach-linux" {
  for_each           = var.linux_name
  virtual_machine_id = azurerm_linux_virtual_machine.linux_vm[each.key].id
  managed_disk_id    = azurerm_managed_disk.assignment1-disk-linux[each.key].id
  lun                = 0
  caching            = "ReadWrite"
  depends_on = [
    azurerm_managed_disk.assignment1-disk-linux,
    azurerm_linux_virtual_machine.linux_vm
  ]
}


# resource "azurerm_backup_protected_vm" "vm1" {
#   resource_group_name = var.rg_name
#   recovery_vault_name = var.recovery_vault_name
#   source_vm_id        = azurerm_linux_virtual_machine.linux_vm[0].id
#   backup_policy_id    = var.backup_policy_id
#   depends_on = [
#       azurerm_linux_virtual_machine.linux_vm
#   ]
# }

# resource "azurerm_backup_protected_vm" "vm2" {
#   resource_group_name = var.rg_name
#   recovery_vault_name = var.recovery_vault_name
#   source_vm_id        = azurerm_linux_virtual_machine.linux_vm[1].id
#   backup_policy_id    = var.backup_policy_id
#   depends_on = [
#       azurerm_linux_virtual_machine.linux_vm
#   ]
# }
