variable "compute_instances" {
  type = map(object({
    boot_disk_size = string
    image = string
    machine_type = string
    network_tier = string
    zone = string
    subnetwork = string
    ssh_keys = map(string)
  }))
}