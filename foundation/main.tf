provider "google" {
  project = var.gcp_project_id
  region  = "eu-north1"
  zone    = "eu-north1-a"
}

data "google_project" "foundation_project" {
  project_id = var.gcp_project_id
}
