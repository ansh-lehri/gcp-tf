locals {
  subnets = {
    for subnet in var.subnets : subnet.name => {
        primary_cidr_range = subnet.primary_cidr_range
        region = subnet.region
        secondary_cidr_ranges = {
            for secondary_cidr_range in subnet.secondary_cidr_ranges : secondary_cidr_range.name => {
                cidr = secondary_cidr_range.cidr
            }
        }
        private_ip_google_access = subnet.private_ip_google_access

    }
  }
}

resource "google_compute_subnetwork" "subnet" {
    for_each = local.subnets
    
    name = each.key
    network = var.subnets_vpc_id
    ip_cidr_range = each.value.primary_cidr_range
    region = each.value.region

    dynamic "secondary_ip_range"{
        for_each = each.value.secondary_cidr_ranges
        content {
          range_name = secondary_ip_range.key
          ip_cidr_range = secondary_ip_range.value.cidr
        }
    }
}