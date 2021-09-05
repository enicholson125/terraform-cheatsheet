module "example_string" {
  # Use specifically the version of the module present in the
  # 085ac8443aae62fbe85a21d2abff88464d750e39 commit version in the repo
  source = "github.com/enicholson125/terraform-cheatsheet.git//example_module?ref=085ac84"

  example_string_length = 10
}
