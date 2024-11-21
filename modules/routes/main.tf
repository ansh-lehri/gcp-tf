locals {
  routes = {
    for route in var.routes : route.name => {
      destination_cidr = route.destination_cidr
      priority = route.priority
      tags = route.tags
      internet_gateway_name = route.internet_gateway_name
    }
  }
}

resource "google_compute_route" "route" {
    for_each = local.routes
    
    name = each.key
    dest_range = each.value.destination_cidr
    network = var.vpc_id
    tags = each.value.tags
    next_hop_gateway = each.value.internet_gateway_name
}