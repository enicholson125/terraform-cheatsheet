# You may notice this module looks like
# a normal piece of terraform configuration.
# That's because it is: modules are just
# terraform configurations in a different location

terraform {
  required_providers {
    random = {
      source = "hashicorp/random"
    }
  }
  required_version = "> 0.15"
}

# Variables aren't required for a module but allow users of the module to
# parameterise what the module creates
variable "example_string_length" {
  description = "The length of string to create in this module."
  type = number
}

resource "random_string" "example_string" {
  length = var.random_string_length
}

# Outputs aren't required for a module but allows the module
# to pass values back to the calling terraform
output "example_string_value" {
  value = random_string.example_string.result
}
