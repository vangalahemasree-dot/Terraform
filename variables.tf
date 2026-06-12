variable "resource_groups" {
  type = list(object({
    name   = string
    region = string
  }))
}
variable "vnets" {
  type = list(object({
    name          = string
    resource_group = string
    address_space = list(string)

    subnets = list(object({
      name             = string
      address_prefixes = list(string)
    }))
  }))
}