variable "formatted_first_names" {
  description = "List of first names, formatted with an initial capital letter."
  default     = ["A", "Bar"]
  type        = list(string)
  validation {
    # Checks that all strings in var.formatted_first_names match the regex
    condition     = alltrue([for name in var.formatted_first_names : length(regexall("[A-Z][a-z]*", name)) > 0])
    error_message = "Names in the list must begin with a capital letter and otherwise be lowercase alphabetic characters."
  }
}
