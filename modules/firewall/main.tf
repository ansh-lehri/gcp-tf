locals {
  firewalls = {
    for firewall in var.firewalls : firewall.fname => {
      name = firewall.name
      priority = firewall.priority
      source_ranges = firewall.source_ranges
      allow_rules = zipmap(
        [ for i,allow_rule in firewall.allow_rules : i ],
        firewall.allow_rules
      )
      deny_rules = zipmap(
        [ for i,deny_rule in firewall.deny_rules : i ],
        firewall.deny_rules
      )
    }
  }
}

resource "google_compute_firewall" "firewalls" {

  for_each = local.firewalls

  name = each.value.name
  network = var.vpc_id
  source_ranges = each.value.source_ranges

  dynamic "allow" {
    for_each = each.value.allow_rules
    content {
      protocol = allow.value.protocol
      ports = allow.value.ports
    } 
  }

  dynamic "deny" {
    for_each = each.value.deny_rules
    content {
      protocol = deny.value.protocol
      ports = deny.value.ports
    } 
  }
}