output "subnet-id" {
    description = "id of Subnet"
    value = {
        for subnet in var.subnets : subnet.name => google_compute_subnetwork.subnet[subnet.name].id
    }
}