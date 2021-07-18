output "all_user_arns" {
  value = aws_iam_user.example[*].arn # Outputs a list of all the arns
}
