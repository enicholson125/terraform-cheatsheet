# This gives the path of the terraform running relative to the directory
# in which the entry terraform was run.
# This example is being run directly, rather than called in a module, so it returns '.'
# path.module is useful when creating and referencing files in a module

output "entry_terraform_path" {
  value = path.module
}
