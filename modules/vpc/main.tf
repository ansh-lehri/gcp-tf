resource "google_compute_network" "vpc" {
    name = var.vpc.name
    auto_create_subnetworks = var.vpc.create_automated_subnets
    routing_mode = var.vpc.vpc_routing_mode
    delete_default_routes_on_create = var.vpc.delete_default_routes
}

resource "google_compute_global_address" "private_ip_range" {
  
  count = var.vpc.private_service_access.create ? 1 : 0
  name          = var.vpc.private_service_access.name
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  address = var.vpc.private_service_access.subnet
  prefix_length = var.vpc.private_service_access.mask
  network       = google_compute_network.vpc.id
}

# Set up VPC peering for Service Networking
resource "google_service_networking_connection" "vpc_peering" {

  count = var.vpc.private_service_access.create ? 1 : 0
  network       = google_compute_network.vpc.id
  service       = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_range[0].name]
}
