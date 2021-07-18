variable "allow_rules" {
  default = {
    "first_rule" = {
      "ports" = [8080, 80],
      "protocol" = "tcp"
    },
    "second_rule" = {
      "ports" = null
      "protocol" = "icmp"
    }
  }
}

resource "google_compute_firewall" "inline_blocks_example" {
  name = "example"
  network = "my-network"

  dynamic "allow" {
    for_each = var.allow_rules

    content {
      ports = allow.value["ports"]
      protocol = allow.value["protocol"]
    }
  }
}
