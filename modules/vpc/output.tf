output "vpc-id" {
    description = "id of VPC"
    value = google_compute_network.vpc.id
}