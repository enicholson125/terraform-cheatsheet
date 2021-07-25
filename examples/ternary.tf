variable "env" {
  default = "prod"
}

resource "random_string" "longer_in_prod" {
  length = var.env == "prod" ? 5 : 3
}

output "string_produced" {
  # Will be 5 characters long
  value = random_string.longer_in_prod.result
}
