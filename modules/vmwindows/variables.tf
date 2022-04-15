variable "windows_name" {
}

variable "windows_availability_set"{
}

variable "windows_vm_size" {
  default = "Standard_F2"
}

variable "vm_admin_user" {
  default = "auto"
}

variable "windows_os_disk_attr" {
  type = map(string)
  default = {
    os_storage_Account_type = "StandardSSD_LRS"
    os_disk_size            = "127"
    os_caching              = "ReadWrite"
  }
}

variable "windows_os_disk_info" {
  type = map(string)
  default = {
    os_publisher = "MicrosoftWindowsServer"
    os_offer     = "WindowsServer"
    os_sku       = "2016-Datacenter"
    os_version   = "latest"
  }
}

variable "location"{
}
variable "rg_name"{
}
variable "tags" {

}

variable "subnet_id" {
}

variable "storage_account_uri" {
  
}
