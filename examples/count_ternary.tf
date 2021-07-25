variable "env" {
  default = "test"
}

resource "random_string" "test_env_only" {
  count  = var.env == "test" ? 1 : 0
  length = 5
}

resource "random_string" "prod_env_only" {
  count  = var.env == "prod" ? 1 : 0
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
