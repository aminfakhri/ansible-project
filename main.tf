module "network" {
    source = "./modules/network"
    rg_name = module.rgroup.rg_name
    location = module.rgroup.location_name
    vnet_name = "Assignment1-vnet"
    vnet_add_space= ["10.0.0.0/16"]
    subnet_name = "Assignment1-subnet"
    subnet_add_space = ["10.0.1.0/24"]
    nsg_name = "Assignment1-nsg"
    tags = local.common_tags
    depends_on =[
      module.rgroup
    ]
}

module "vmlinux" {
    source = "./modules/vmlinux"
    # vm_name = "Assignment1-linux"
    linux_availability_set = "linux_avs"
    linux_name = {
    "linux1" = "Standard_B1s"
    "linux2" = "Standard_B1s"
  }
    # nb_count = 2
    location = module.rgroup.location_name
    rg_name = module.rgroup.rg_name
    subnet_id = module.network.subnet_id
    storage_account_uri = module.common.storage_account_uri
    tags = local.common_tags
    depends_on =[
      module.rgroup,
      module.network,
    ]
}

module "vmwindows" {
    source = "./modules/vmwindows"
    windows_name = "winvm"
    windows_availability_set = "windows_avs"
    location = module.rgroup.location_name
    rg_name = module.rgroup.rg_name
    subnet_id = module.network.subnet_id
    storage_account_uri = module.common.storage_account_uri
    tags = local.common_tags
    depends_on =[
      module.rgroup,
      module.network
    ]
}

module "rgroup" {
    source = "./modules/rgroup"
    location = "canadaCentral"
    rg_name = "assignment2-rg"
    tags = local.common_tags
}

#module "datadisk" {
    #source = "./modules/datadisk"
    #location = module.rgroup.location_name
    #rg_name = "assignment2-rg"
    #linux_name = module.vmlinux.linux_vm_hostname
    #linux_id   = module.vmlinux.linux_vm_id
    # linux_datadisk1_name = "assignment1-datadisk1-linux"
    # linux_datadisk2_name = "assignment1-datadisk2-linux"
    #win_datadisk3_name = "assignment1-datadisk3-win"
    # linux_vm1_id = module.vmlinux.linux_vm_id
    # linux_vm2_id = module.vmlinux.linux_vm2_id
    #windows_id = module.vmwindows.Windows_VM_Id
    #tags = local.common_tags
    #depends_on =[
    #module.vmwindows,
    # module.vmlinux
    #]
#}

module "loadbalancer" {
    source = "./modules/loadbalancer"
    lb_name = "assignment1-lb"
    public_ip_lb_name = "assignment1-publicip-lb"
    location = module.rgroup.location_name
    rg_name = module.rgroup.rg_name
    subnet_id = module.network.subnet_id
    linux_nic   = module.vmlinux.linux_nic
    windows_nic = module.vmwindows.Windows_vm_nic
    tags = local.common_tags
    depends_on = [
        module.vmlinux,
        module.vmwindows
    ]
    
}

module "common" {
    source = "./modules/common"
    recovery_service_vault_name = "assignment1-vault"
    log_analytics_workspace_name = "assignmnent1-loganalytics-workspace"
    storage_account_name = "assign1stoac"
    location = module.rgroup.location_name
    rg_name = module.rgroup.rg_name
    tags = local.common_tags
    depends_on = [
        module.rgroup,
]
    
}

module "database" {
    source = "./modules/database"
    db_server_name = "assignment1-amin6010-db-server"
    db_name = "assignment1-postgre_server-db"
    location = module.rgroup.location_name
    rg_name = module.rgroup.rg_name
    tags = local.common_tags
    depends_on = [
        module.loadbalancer
    ]
    
}
