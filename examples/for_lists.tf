variable "favourite_vegetables" {
  default = ["Artichoke", "Broccoli", "Potato"]
}

output "vegetable_statements" {
  value = [for veg in var.favourite_vegetables : "${veg} is great."]
}
