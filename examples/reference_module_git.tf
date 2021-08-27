module "example_string" {
  source = "git::https://github.com/enicholson125/terraform-cheatsheet/examples/example_module.git"

  example_string_length = 10
}
