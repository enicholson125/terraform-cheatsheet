# You can combine version constraints. For example, this
# configuration requires a terraform version greater than
# 0.15.0 but less than or equal to 0.15.8, excluding 0.15.6

terraform {
  required_version = "> 0.15.0, <= 0.15.8, != 0.15.6"
}
