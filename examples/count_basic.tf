variable "string_lengths" {
  default = [2, 5, 1]
}

resource "random_string" "count_basic" {
  count = length(var.string_lengths)

  length = var.string_lengths[count.index]
}
