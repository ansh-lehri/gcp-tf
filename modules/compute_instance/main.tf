resource "google_compute_instance" "compute_instances" {

  for_each = var.compute_instances

  name = each.key
    boot_disk {
      initialize_params {
        image = each.value.image
        size = each.value.boot_disk_size
      }
    }
    metadata = {
    ssh-keys = join(
      "\n",
      [for username, key_path in each.value.ssh_keys : "${username}:${file(key_path)}"]
    )
  }
    machine_type = each.value.machine_type
    zone = each.value.zone
    network_interface {
      subnetwork = each.value.subnetwork
      access_config {
        network_tier = each.value.network_tier
      }
    } 
}