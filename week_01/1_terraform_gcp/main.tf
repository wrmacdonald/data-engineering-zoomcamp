terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.36.0"
    }
  }
}

provider "google" {
  project = "terraform-demo-428220"
  region  = "us-west1"
}