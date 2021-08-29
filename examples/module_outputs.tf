module "example_string" {
  source = "./example_module"

  example_string_length = 10
}

output "example_module_output" {
  # This prints the example_string_value output defined in the
  # example_string module. You can only reference outputs defined
  # by a module, you cannot directly reference resources in them
  value = module.example_string.example_string_value
}
