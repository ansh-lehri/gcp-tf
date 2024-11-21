variable "routes" {
  type = list(object({
    name = string
    destination_cidr = string
    priority = number
    tags = list(string)
    internet_gateway_name = string
  }))

  validation {
    condition = alltrue([for route in var.routes : route.priority >= 0 && route.priority <= 65535])
    error_message = "priority value should be in range 0-65535"
  }
}

variable "vpc_id" {
  type = string
}