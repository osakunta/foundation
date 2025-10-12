
variable "gcp_project_id" {
  type        = string
  description = "The GCP project ID for the foundation project."
}

variable "billing_account_id" {
  type        = string
  description = "The GCP billing account ID."
}

variable "tfc_hostname" {
  type        = string
  description = "The hostname for your Terraform Cloud instance (e.g. app.terraform.io)."
}

variable "tfc_organization_name" {
  type        = string
  description = "The name of your Terraform Cloud organization."
}

variable "tfc_project_name" {
  type        = string
  description = "The name of your Terraform Cloud project."
}

variable "tfc_workspace_name" {
  type        = string
  description = "The name of your Terraform Cloud workspace."
}
