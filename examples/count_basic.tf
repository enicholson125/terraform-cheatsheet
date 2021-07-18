variable "user_names" {
  default = ["boyle", "holt", "diaz"]
}

resource "aws_iam_user" "example" {
  count = length(var.user_names)
  name = var.user_names[count.index]
}
