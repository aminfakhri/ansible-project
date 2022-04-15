
resource "azurerm_managed_disk" "assignment1-disk-win" {
  name                 = var.win_datadisk3_name
  location             = var.location
  resource_group_name  = var.rg_name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 10
  tags = var.tags
}


resource "azurerm_virtual_machine_data_disk_attachment" "assignment1-attach-win" {
  managed_disk_id    = azurerm_managed_disk.assignment1-disk-win.id
  virtual_machine_id = var.windows_id
  lun                = "10"
  caching            = "ReadWrite"
  depends_on = [
    azurerm_managed_disk.assignment1-disk-win
  ]
  
}

# Linux
resource "azurerm_managed_disk" "assignment1-disk-linux" {
  count = length(var.linux_name)

  name                 = "${element(var.linux_name[*], count.index + 1)}-data-disk"
  location             = var.location
  resource_group_name  = var.rg_name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 10
  tags = var.tags
}


resource "azurerm_virtual_machine_data_disk_attachment" "assignment1-attach-linux" {
  count = length(var.linux_name)
  virtual_machine_id = element(var.linux_id[*], count.index)
  managed_disk_id    = element(azurerm_managed_disk.assignment1-disk-linux[*].id, count.index + 1)
  lun                = 0
  caching            = "ReadWrite"
  depends_on = [
    azurerm_managed_disk.assignment1-disk-linux
  ]
}