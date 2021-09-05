# Particularly useful when working with the
# AWS provider, as it makes IAM policy writing neater

output "example_json_policy" {
  value = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}
