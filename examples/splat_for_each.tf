resource "aws_iam_user" "example" {

}

output "all_user_arns" {
  value = values(aws_iam_user.example[*].arn)
}
