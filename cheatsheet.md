# Terraform config cheatsheet
## Loops
### for_each
Creating multiple resources with for_each:
```
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

```
Creating multiple inline blocks in a resource:
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
### count
Better in general to use for_each as count makes the resources addresses less readable and will recreate all the resources if you remove the first one in the array (as their index will have changed). However, if you do want to use it:
```
variable "user_names" {
  default = ["boyle", "holt", "diaz"]
}

resource "aws_iam_user" "example" {
  count = length(var.user_names)
  name = var.user_names[count.index]
}

```
Very useful with ternaries for flagging resources on and off:
```
resource "aws_iam_user" "test_env_only" {
  count = var.env == "test" ? 1 : 0
  name = "test-only"
}

output "test_env_only" {
  value = aws_iam_user.test_env_only[0]
}

```
### for
Iterating over lists with for:
```
variable "favourite_vegetables" {
  default = ["Artichoke", "Broccoli", "Potato"]
}

# Outputs ["Artichoke is great.", "Broccoli is great.", "Potato is great."]
output "vegetable_statements" {
  value = [for veg in var.favourite_vegetables : "${veg} is great."]
}

```
Iterating over maps with for:
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
### splat
Splat with resources created using count:
```
output "all_user_arns" {
  value = aws_iam_user.example[*].arn # Outputs a list of all the arns
}

```
Splat with resources created using for_each
```
resource "aws_iam_user" "example" {

}

output "all_user_arns" {
  value = values(aws_iam_user.example[*].arn)
}

```
For in strings (string directive)
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
Very useful for flagging based on environments:
```
resource "aws_iam_user" "ternary" {
  name = var.env == "prod" ? "prod-user" : "test-user"
}

```
## String interpolations (templating)
If the value you're interpolating is an attribute of a resource then Terraform will infer the dependency between the two, that is it won't try to build the resource containing the interpolation until it has built the resource that is referenced.
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
This is particularly if you're working in AWS, as it makes writing IAM policies neater
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
