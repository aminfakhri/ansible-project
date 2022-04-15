resource "azurerm_public_ip" "assignment1_pip" {
  name                = var.public_ip_lb_name
  location            = var.location
  resource_group_name = var.rg_name
  allocation_method   = "Static"
}

resource "azurerm_lb" "assignment1_lb" {
  name                = var.lb_name
  location            = var.location
  resource_group_name = var.rg_name

  frontend_ip_configuration {
    name                 = "lb_assignment"
    public_ip_address_id = azurerm_public_ip.assignment1_pip.id
  }
}

resource "azurerm_lb_backend_address_pool" "assignment1_backend_pool" {
  name            = "BackEndAddressPool"
  loadbalancer_id = azurerm_lb.assignment1_lb.id
}
resource "azurerm_network_interface_backend_address_pool_association" "assignment1_add_pool_asso" {
  count                   = length(var.linux_nic)
  ip_configuration_name   = element(var.linux_nic[*].ip_configuration[0].name, count.index)
  network_interface_id    = element(var.linux_nic[*].id, count.index)
  backend_address_pool_id = azurerm_lb_backend_address_pool.assignment1_backend_pool.id
}

resource "azurerm_lb_probe" "assignment1_lb_probe" {
  resource_group_name = var.rg_name
  loadbalancer_id     = azurerm_lb.assignment1_lb.id
  name                = "http-running-probe"
  port                = 80
}

resource "azurerm_lb_rule" "assignment1_lb_rule" {
  resource_group_name            = var.rg_name
  loadbalancer_id                = azurerm_lb.assignment1_lb.id
  name                           = "LBRule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = azurerm_lb.assignment1_lb.frontend_ip_configuration[0].name
}


