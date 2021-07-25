terraform {
  required_providers {
    random = {
      source = "hashicorp/random"
    }
    archive = {
      source = "hashicorp/archive"
    }
  }
  required_version = "> 0.15"
}
