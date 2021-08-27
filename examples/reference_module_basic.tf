module "example_string" {
  # Path to module relative to this file
  source = "../example_module/main.tf"

  example_string_length = 10
}
