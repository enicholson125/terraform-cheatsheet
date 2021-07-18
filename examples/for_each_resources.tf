variable "iterator" {
  default = ["peralta", "santiago"]
}

resource "local_file" "for_each_example" {
  for_each = toset(var.iterator)
  content = each.value
  filename = "${path.module}/${each.value}.yaml"
}

output "local_files_created" {
  value = local_file.for_each_example # Will output a map of the files, keyed by var.iterator
}
