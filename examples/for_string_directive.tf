variable "fruits" {
  default = ["apple", "tangerine", "mango"]
}

output "for_within_string" {
  # ~ character strips empty newlines and whitespace
  value = <<EOF
%{~for fruit in var.fruits}
  ${fruit}
%{~endfor}
EOF
}
