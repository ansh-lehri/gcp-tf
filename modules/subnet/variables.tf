variable "subnets" {
  type = list(object({
    name = string
    primary_cidr_range = string
    region = string
    secondary_cidr_ranges = list(object({
      name = string
      cidr = string
    private_ip_google_access = bool
    }))
  }))
}

variable "subnets_vpc_id" {
  type = string
}