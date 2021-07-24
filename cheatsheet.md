# Terraform config cheatsheet
## Loops
### for_each
Creating multiple resources with for_each:
```
# Could also iterate over [2, 5] directly, however
# this could cause confusion as to whether the numbers
# are an index rather than a key
variable "iterator" {
  default = ["short_string", "longer_string"]
}

variable "lengths" {
  default = {
    short_string = 2,
    longer_string = 5
  }
}

resource "random_string" "for_each_example" {
  for_each = toset(var.iterator)

  length = var.lengths[each.value]
}

output "strings_created" {
  # Outputs a map of the string resources, keyed by var.iterator values
  value = random_string.for_each_example
}

output "long_string_length" {
  value = random_string.for_each_example["longer_string"].length # 5
}

```
Creating multiple inline blocks in a resource:
```
variable "zip_sources" {
  default = {
    first_source = {
      source_content = "Some text in my first source"
      filename = "first_source.txt"
    }

    second_source = {
      source_content = "Some text in my second source."
      filename = "second_source.txt"
    }
  }
}

data "archive_file" "inline_block_example" {
  type        = "zip"
  output_path = "example.zip"

  # Generates two inline blocks of the form:
  # source {
  #   content = <content>
  #   filename = <filename>
  # }
  dynamic "source" {
    for_each = var.zip_sources

    content {
      content = source.value["source_content"]
      filename = source.value["filename"]
    }
  }
}

```
### count
Better in general to use for_each as count makes the resources addresses less readable and will recreate all the resources if you remove the first one in the array (as their index will have changed). However, if you do want to use it:
```
variable "string_lengths" {
  default = [2, 5, 1]
}

resource "random_string" "count_basic" {
  count = length(var.string_lengths)

  length = var.string_lengths[count.index]
}

```
Very useful with ternaries for flagging resources on and off:
```
variable "env" {
  default = "test"
}

resource "random_string" "test_env_only" {
  count = var.env == "test" ? 1 : 0
  length = 5
}

resource "random_string" "prod_env_only" {
  count = var.env == "prod" ? 1 : 0
  length = 5
}

output "test_env_only" {
  # We need this ternary or the terraform will fail to plan when
  # var.env != "test" (because random_string.test_env_only[0] will not exist)
  value = var.env == "test" ? random_string.test_env_only[0] : null
}

output "prod_env_only" {
  value = var.env == "prod" ? random_string.prod_env_only[0] : null
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
Using for within a string (string directive)
```
variable "fruits" {
  default = ["apple", "tangerine", "mango"]
}

# Outputs (each on a new line):
# apple
# tangerine
# mango
output "for_within_string" {
  value = <<EOF
%{~ for fruit in var.fruits } # ~ character strips empty newlines and whitespace
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
## Get path of module
Path to the module that this configuration is in:
```
output "module_path" {
  value = module.path
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

```

