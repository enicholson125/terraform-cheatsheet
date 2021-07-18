resource "aws_iam_user" "test_env_only" {
  count = var.env == "test" ? 1 : 0
  name = "test-only"
}

output "test_env_only" {
  value = aws_iam_user.test_env_only[0]
}
