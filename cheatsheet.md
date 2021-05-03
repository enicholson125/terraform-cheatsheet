# Terraform Config cheatsheet
## Loops
### For_each
Creating multiple resources:
```
variable "users" {
  default = ["james", "esme"]
}

resource "aws_iam_user" "splat" {
  for_each = toset(var.users)
  name = each.value
}

output "all_users" {
  value = aws_iam_user.example # Will output a map of the users, keyed by var.users
}
```
Creating multiple inline blocks:
```
variable "allow_rules" {
  default = {
    "first_rule" = {
      "ports" = [8080, 80],
      "protocol" = "tcp"
    },
    "second_rule" = {
      "ports" = null
      "protocol" = "icmp"
    }
  }
}

resource "google_compute_firewall" "inline_blocks_example" {
  name = "example"
  network = "my-network"

  dynamic "allow" {
    for_each = var.allow_rules

    content {
      ports = allow.value["ports"]
      protocol = allow.value["protocol"]
    }
  }
}
```
### Count
```
resource "aws_iam_user" "example" {
  count = length(var.user_names)
  name = var.user_names[count.index]
}
```
Better in general to use for_each: count makes the resource addresses less readable and will recreate all the resources if you remove the first one in the array.
```
resource "aws_iam_user" "test_env_only" {
  count = var.env == "test" ? 1 : 0
  name = "test-only"
}

output "test_env_only" {
  value = aws_iam_user.test_env_only[0]
}
```
### For
Lists:
```
variable "favourite_vegetables" {
  default = ["Artichoke", "Broccoli", "Potato"]
}

# Outputs ["Artichoke is great.", "Broccoli is great.", "Potato is great."]
output "vegetable_statements" {
  value = [for veg in var.favourite_vegetables : "${veg} is great."]
}
```
Maps:
```
variable "vegetable_opinions" {
  default = {
    artichoke = "great"
    cauliflower = "terrible"
  }
}

# Outputs {"ARTICHOKE" = "GREAT", "CAULIFLOWER" = "TERRIBLE"}
output "uppercase_opinions" {
  value = {for veg, opinion in var.vegetable_opinions : upper(veg) => upper(opinion)}
}
```
### Splat
For resources created with count:
```
output "all_user_arns" {
  value = aws_iam_user.example[*].arn # Outputs a list of all the arns
}
```
For resources created with for_each:
```
output "all_user_arns" {
  value = values(aws_iam_user.example[*].arn)
}
```
### For in strings (string directive)
```
variable "fruits" {
  default = ["apple", "tangerine", "mango"]
}

# Outputs (each on a new line):
# apple
# tangerine
# mango
output "string_directive" {
  value = <<EOF
%{~ for fruit in var.fruits } # ~ strips empty newlines and whitespace
  ${fruit}
%{~ endfor }
EOF
}
```
## Ternary
```
resource "aws_iam_user" "ternary" {
  name = var.env == "prod" ? "prod-user" : "test-user"
}
```
## String interpolations (templating)
```
variable "your_variable" {
  default = "set-me-to-anything"
  type = string
}

resource "aws_iam_user" "string_templating" {
  name = "${var.your_variable}-user"
}
```
## JSON encoding
```
resource "aws_iam_policy" "policy" {
  name        = "test_policy"
  path        = "/"
  description = "My test policy"

  policy = jsonencode({
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
```
