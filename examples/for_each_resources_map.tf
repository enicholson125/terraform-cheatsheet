variable "pet_prefixes_and_lengths" {
  default = {
    "five-long" : 5,
    "seven-long" : 7
  }
}

resource "random_pet" "for_each_example" {
  for_each = var.pet_prefixes_and_lengths

  prefix = each.key
  length = each.value
}

output "prefixed_pets_created" {
  # Outputs a map of the string resources, keyed by the var.pet_prefixes_and_lengths keys
  value = random_pet.for_each_example
}

output "short_pet_length" {
  value = random_pet.for_each_example["five-long"].length # Should be 5
}
