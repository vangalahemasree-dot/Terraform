resource "azurerm_resource_group" "rg" {
  for_each = {
    for rg in var.resource_groups :
    rg.name => rg
  }

  name     = each.value.name
  location = each.value.region
}
resource "azurerm_virtual_network" "vnet" {
  for_each = {
    for vnet in var.vnets :
    vnet.name => vnet
  }

  name                = each.value.name
  resource_group_name = each.value.resource_group

  location = azurerm_resource_group.rg[
    each.value.resource_group
  ].location

  address_space = each.value.address_space
}
resource "azurerm_subnet" "subnet" {

  for_each = merge([
    for vnet in var.vnets : {
      for subnet in vnet.subnets :
      "${vnet.name}-${subnet.name}" => {
        vnet_name        = vnet.name
        resource_group   = vnet.resource_group
        subnet_name      = subnet.name
        address_prefixes = subnet.address_prefixes
      }
    }
  ]...)

  name                 = each.value.subnet_name
  resource_group_name  = each.value.resource_group

  virtual_network_name = azurerm_virtual_network.vnet[
    each.value.vnet_name
  ].name

  address_prefixes = each.value.address_prefixes
}