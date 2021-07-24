variable "string_lengths" {
  default = [2, 5, 1]
}

resource "random_string" "splat_count" {
  count = length(var.string_lengths)

  length = var.string_lengths[count.index]
}

output "all_random_strings_created" {
  # Outputs a list of all the random_strings created
  value = random_string.splat_count[*].result
}
