variable "fruits" {
  default = ["apple", "tangerine", "mango"]
}

# Outputs (each on a new line):
# apple
# tangerine
# mango
output "for_within_string" {
  value = <<EOF
%{~for fruit in var.fruits} # ~ character strips empty newlines and whitespace
  ${fruit}
%{~endfor}
EOF
}
