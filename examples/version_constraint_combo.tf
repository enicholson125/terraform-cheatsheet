# You can combine version constraints. For example, this
# configuration requires a terraform version greater than
# 0.15.0 but less than or equal to 0.15.5, excluding 0.15.3

terraform {
  required_version = "> 0.15.0, <= 0.15.5, != 0.15.3"
}
