# Terraform Config cheatsheet
## Loops
### Count
```
resource "aws_iam_user" "example" {
  count = length(var.user_names)
  name = var.user_names[count.index]
}
```
Better to use for_each: count makes the resource addresses less readable and will recreate all the resources if you remove the first one in the array.
```
resource "aws_iam_user" "test_env_only" {
  count = var.env == "test" ? 1 : 0
  name = "test-only"
}
```
## Ternary
```
resource "aws_iam_user" "ternary" {
  name = var.env == "prod" ? "prod-user" : "test-user"
}
```
## String templating
```
variable "your_variable" {
  default = "set-me-to-anything"
  type = string
}

resource "aws_iam_user" "string_templating" {
  name = "${var.your_variable}-user"
}
```
