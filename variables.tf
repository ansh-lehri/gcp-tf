variable "gcp_project" {
  type = string
}

variable "gcp_region" {
  type = string
}

variable "gcp_zone" {
  type = string
}

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

variable "subnets" {
  type = list(object({
    name = string
    primary_cidr_range = string
    region = string
    secondary_cidr_ranges = list(object({
      name = string
      cidr = string
    }))
    private_ip_google_access = bool
  }))
}

variable "routes" {
  type = list(object({
    name = string
    destination_cidr = string
    vpc_name = string
    priority = number
    tags = list(string)
    internet_gateway_name = string
  }))
}

variable "firewalls"{
  type = list(object({
    name = string
    fname = string
    vpc_name = string
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
}

variable "compute_instances" {
  type = list(object({
    name = string
    image = string
    boot_disk_size = number
    machine_type = string
    zone = string
    subnetwork = string
    network_tier = string
    ssh_keys = map(string)
  }))
}

variable "bucket" {
  type = object({
    name = string
    location = string
    cors = list(object({
      origin = list(string)
      method = list(string)
    }))
    website = object({
      main_page_suffix = string
      not_found_page = string
    })
  })
  
}

variable "mysql" {
  type = object({
    instance_name = string
    db_version = string
    instance_tier = string
    db = object({
      name = string
    }) 
  })
  
}
