# Better to use for_each if you can, as count makes the resources
# addresses less readable (e.g. random_string.count_basic[0])
# will recreate all the resources if you remove the first one in
# the array (as their index will have changed).
# However, if you're hitting errors like:
# "value depends on resource attributes that cannot be determined until apply"
# then using count can be a good workaround

variable "string_lengths" {
  default = [2, 5, 1]
}

resource "random_string" "count_basic" {
  count = length(var.string_lengths)

  length = var.string_lengths[count.index]
}
