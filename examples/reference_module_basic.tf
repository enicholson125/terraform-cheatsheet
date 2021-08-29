module "example_string" {
  # Path to module relative to running terraform. './' is required
  # if first element of path is in the same directory.
  # This module is in a directory called example_module
  # located in the same directory as this terraform
  source = "./example_module"

  example_string_length = 10
}
