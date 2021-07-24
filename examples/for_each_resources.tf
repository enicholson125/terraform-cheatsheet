# Could also iterate over [2, 5] directly, however
# this could cause confusion as to whether the numbers
# are an index rather than a key
variable "iterator" {
  default = ["short_string", "longer_string"]
}

variable "lengths" {
  default = {
    short_string = 2,
    longer_string = 5
  }
}

resource "random_string" "for_each_example" {
  for_each = toset(var.iterator)

  length = var.lengths[each.value]
}

output "strings_created" {
  # Outputs a map of the string resources, keyed by var.iterator values
  value = random_string.for_each_example
}

output "long_string_length" {
  value = random_string.for_each_example["longer_string"].length # 5
}
