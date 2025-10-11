terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.8.0"
    }
  }
}

variable "foundation_project_id" {
  type        = string
  description = "The GCP project ID for the foundation project."
}

provider "google" {
  project = var.foundation_project_id
  region  = "eu-north1"
  zone    = "eu-north1-a"
}

resource "google_storage_bucket" "pulumi-state-bucket" {
  name     = "${var.foundation_project_id}-pulumi-state"
  location = "EU"
}
