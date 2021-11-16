variable "sauce_for_roast_lamb" {
  description = "Which sauce to serve with roast lamb. Options are mint or redcurrant jelly."
  type        = string
  # Variable validation gives you a faster feedback loop as invalid variables will
  # fail at plan rather than apply (and will not create incorrect resources). It also reduces
  # errors if your modules is being used by third parties.
  validation {
    # Only the variable being validated can be referenced in the condition,
    # no other variables, resources or locals can be referenced
    condition = (var.sauce_for_roast_lamb == "mint" ||
    var.sauce_for_roast_lamb == "redcurrant jelly")
    # Terraform is very opinionated about this error message and will fail if
    # it doesn't begin with a capital letter and end with a full stop.
    error_message = "The sauce must be either mint or redcurrant jelly."
  }
}
