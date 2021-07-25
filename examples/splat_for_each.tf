variable "iterator" {
  default = ["2", "5"]
}

resource "random_string" "for_each_splat" {
  for_each = toset(var.iterator)

  length = each.value
}

output "map_of_resources_created" {
  value = random_string.for_each_splat[*]
}
