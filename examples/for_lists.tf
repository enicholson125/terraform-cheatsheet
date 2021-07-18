variable "favourite_vegetables" {
  default = ["Artichoke", "Broccoli", "Potato"]
}

# Outputs ["Artichoke is great.", "Broccoli is great.", "Potato is great."]
output "vegetable_statements" {
  value = [for veg in var.favourite_vegetables : "${veg} is great."]
}
