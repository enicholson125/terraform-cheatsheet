module "example_string" {
  # Path to module relative to running terraform
  source = "./examples/example_module/main.tf"

  example_string_length = 10
}
