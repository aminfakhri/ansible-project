resource "azurerm_availability_set" "windows_avs" {
  name                = var.windows_availability_set
  location            = var.location
  resource_group_name = var.rg_name
  platform_fault_domain_count  = 2
  platform_update_domain_count = 5

  tags = var.tags
}

resource "azurerm_windows_virtual_machine" "windows_vm" {
  name = var.windows_name
  resource_group_name = var.rg_name
  availability_set_id = azurerm_availability_set.windows_avs.id
  location            = var.location
  size                = var.windows_vm_size
  admin_username      = var.vm_admin_user
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.windows_nic.id
  ]
  winrm_listener {
  protocol = "Http"
}
boot_diagnostics {
    storage_account_uri = var.storage_account_uri
  }

  

  os_disk {
    name = "win-os_disk"
    caching              = var.windows_os_disk_attr.os_caching
    storage_account_type = var.windows_os_disk_attr.os_storage_Account_type
  }

  source_image_reference {
    publisher = var.windows_os_disk_info.os_publisher
    offer     = var.windows_os_disk_info.os_offer
    sku       = var.windows_os_disk_info.os_sku
    version   = var.windows_os_disk_info.os_version
  }
  tags = var.tags
  lifecycle {
  }
}

resource "azurerm_network_interface" "windows_nic" {
  name                = "win-nic"
  location            = var.location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.windows_pip.id
  }
  tags = var.tags
  lifecycle {
   
  }
}

resource "azurerm_public_ip" "windows_pip" {
  name                = "win-pip"
  resource_group_name = var.rg_name
  location            = var.location
  allocation_method   = "Static"
  tags                = var.tags
  domain_name_label   = var.windows_name
  lifecycle {
    
  }
}

resource "azurerm_virtual_machine_extension" "windows_extension" {
  name                 = "antimalware_extension"
  virtual_machine_id   = azurerm_windows_virtual_machine.windows_vm.id
  publisher = "Microsoft.Azure.Security"
  type = "IaaSAntimalware"
  type_handler_version = "1.3"
  auto_upgrade_minor_version = "true"
  settings = <<SETTINGS
    {
        "AntimalwareEnabled": true,
        "RealtimeProtectionEnabled": "true",
        "ScheduledScanSettings": 
        {
          "isEnabled": "true",
          "day": "1",
          "time": "120",
          "scanType": "Quick"
        },
        "Exclusions": 
        {
          "Extensions": "",
          "Paths": "",
          "Processes": ""
        }
    }
SETTINGS

   depends_on = [
      azurerm_windows_virtual_machine.windows_vm
  ]

  tags = var.tags
}
