# If the value you're interpolating is part of a resource
# then Terraform will infer the dependency between the two -
# it won't try to build the resource containing the interpolation
# until it has built the referenced resource.

resource "random_string" "insertion" {
  length = 7
}

locals {
  my_string = "Random string value is ${random_string.insertion.result}"
}

output "my_string" {
  value = local.my_string
}
