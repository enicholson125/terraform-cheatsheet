resource "random_string" "insertion" {
  length = 7
}

local {
  my_string = "Random string value is ${random_string.insertion.result}"
}

output "my_string" {
  value = local.my_string
}
