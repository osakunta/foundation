
variable "gcp_project_id" {
  type        = string
  description = "The GCP project ID for the foundation project."
}

variable "billing_account_id" {
  type        = string
  description = "The GCP billing account ID."
}

variable "tfc_organization_id" {
  type        = string
  description = "The ID of your Terraform Cloud organization."
}

variable "tfc_project_id" {
  type        = string
  description = "The ID of your Terraform Cloud project."
}

variable "tfc_foundation_workspace_id" {
  type        = string
  description = "The ID of the foundation workspace."
}

variable "tfc_osakunta_website_workspace_id" {
  type        = string
  description = "The ID of the osakunta-website workspace."
}
