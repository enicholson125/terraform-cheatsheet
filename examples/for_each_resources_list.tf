variable "iterator" {
  default = ["2", "5"]
}

resource "random_string" "for_each_example" {
  for_each = toset(var.iterator)

  length = each.value
}

output "strings_created" {
  # Outputs a map of the string resources, keyed by var.iterator values
  value = random_string.for_each_example
}

output "long_string_length" {
  value = random_string.for_each_example["5"].length # Should be 5
}
