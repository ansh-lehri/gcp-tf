variable "vpc" {
  type = object({
    name = string
    private_service_access = object({
      create = bool
      name = string
      subnet = string
      mask = string
    })
    delete_default_routes = bool
    create_automated_subnets = bool
    vpc_routing_mode = string
  })
}

variable "vpc_name" {
  type = string
}

variable "create_automated_subnets" {
  type = bool
  default = false
}

variable "vpc_routing_mode" {
    type = string
    default = "REGIONAL"
}

variable "delete_default_routes" {
    type = bool
    default = false
}