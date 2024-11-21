variable "firewalls" {
  type = list(object({
    name = string
    fname = string
    allow_rules = list(object({
      protocol = string
      ports = list(string)
    }))
    deny_rules = list(object({
      protocol = string
      ports = list(string)
    }))
    priority = number
    source_ranges = list(string)
  }))

  validation {
    condition = alltrue([for firewall in var.firewalls : can (regex("[a-z]([-a-z0-9]*[a-z0-9])?",firewall.name))])
    error_message = "priority value should be in range 0-65535"
  }
}

variable "vpc_id" {
  type = string
}