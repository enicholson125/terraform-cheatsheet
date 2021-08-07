# This gives the path of the terraform running
# relative to the directory in which the entry
# terraform was run.
# This is the entry terraform, so it returns '.'
# This is useful when creating and referencing
# non-terraform files bundled into a module

output "entry_terraform_path" {
  value = path.module
}
