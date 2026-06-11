variable "resource_groups" {
  type = list(object({
    name   = string
    region = string
  }))
}