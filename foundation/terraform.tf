terraform {
  # cloud {
  #   organization = "satalinnan-saatio"
  #   workspaces {
  #     name = "satakuntatalo-foundation"
  #   }
  # }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.8.0"
    }
  }
}
