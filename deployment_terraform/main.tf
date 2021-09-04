
terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
  required_version = ">= 1"
  backend "gcs" {
    bucket = "terraform-cheatsheet-tf-state"
    prefix = "terraform/state"
  }
}

variable "project_id" {
  type        = string
  description = "ID of the Google project to create this infrastructure in"
}

provider "google" {
  project = var.project_id
  region  = "europe-west1"
}

resource "google_storage_bucket" "state" {
  name     = "terraform-cheatsheet-tf-state"
  location = "EU"
}

resource "google_storage_bucket" "website" {
  name     = "terraform-cheatsheet"
  location = "EU"

  website {
    main_page_suffix = "index.html"
    # not_found_page   = "404.html"
  }
  #   cors {
  #     origin          = ["http://image-store.com"]
  #     method          = ["GET", "HEAD", "PUT", "POST", "DELETE"]
  #     response_header = ["*"]
  #     max_age_seconds = 3600
  #   }
}

# resource "google_storage_bucket_object" "index_css" {
#   name   = "index.css"
#   source = "../src/index.css"
#   bucket = google_storage_bucket.website.name

#   content_type = "text/css"
# }
