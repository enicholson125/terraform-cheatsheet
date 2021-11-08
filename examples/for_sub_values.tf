resource "random_pet" "my_animals" {
  count = 5
}

output "farm_register" {
  value = [ for pet in random_pet.my_animals[*] : pet.id ]
}
