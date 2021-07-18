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
