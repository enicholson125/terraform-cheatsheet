variable "vegetable_opinions" {
  default = {
    artichoke   = "great"
    cauliflower = "terrible"
  }
}

# Outputs {"ARTICHOKE" = "GREAT", "CAULIFLOWER" = "TERRIBLE"}
output "uppercase_opinions" {
  value = { for veg, opinion in var.vegetable_opinions : upper(veg) => upper(opinion) }
}
