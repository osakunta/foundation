resource "google_iam_workload_identity_pool" "tfc_pool" {
  workload_identity_pool_id = "tfc-pool-1"
}

resource "google_iam_workload_identity_pool_provider" "tfc_provider" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.tfc_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "tfc-provider-id"

  attribute_mapping = {
    "google.subject"                        = "assertion.sub",
    "attribute.aud"                         = "assertion.aud",
    "attribute.terraform_run_phase"         = "assertion.terraform_run_phase",
    "attribute.terraform_project_id"        = "assertion.terraform_project_id",
    "attribute.terraform_project_name"      = "assertion.terraform_project_name",
    "attribute.terraform_workspace_id"      = "assertion.terraform_workspace_id",
    "attribute.terraform_workspace_name"    = "assertion.terraform_workspace_name",
    "attribute.terraform_organization_id"   = "assertion.terraform_organization_id",
    "attribute.terraform_organization_name" = "assertion.terraform_organization_name",
    "attribute.terraform_run_id"            = "assertion.terraform_run_id",
    "attribute.terraform_full_workspace"    = "assertion.terraform_full_workspace",
  }
  oidc {
    issuer_uri = "https://${var.tfc_hostname}"
    # The default audience format used by TFC is of the form:
    # //iam.googleapis.com/projects/{project number}/locations/global/workloadIdentityPools/{pool ID}/providers/{provider ID}
    # which matches with the default accepted audience format on GCP.
    #
    # Uncomment the line below if you are specifying a custom value for the audience instead of using the default audience.
    # allowed_audiences = [var.tfc_gcp_audience]
  }
  attribute_condition = "assertion.sub.startsWith(\"organization:${var.tfc_organization_name}:project:${var.tfc_project_name}:workspace:${var.tfc_workspace_name}\")"
}

resource "google_service_account" "tfc_service_account" {
  account_id   = "tfc-service-account"
  display_name = "HCP Terraform Service Account"
}

resource "google_service_account_iam_member" "tfc_service_account_member" {
  service_account_id = google_service_account.tfc_service_account.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.tfc_pool.name}/*"
}

resource "google_project_iam_member" "tfc_project_member" {
  project = var.gcp_project_id
  role    = "roles/editor"
  member  = "serviceAccount:${google_service_account.tfc_service_account.email}"
}

resource "google_folder_iam_member" "tfc_sa_osakunta_folder_member" {
  folder = google_folder.osakunta_folder.id
  for_each = toset([
    "roles/resourcemanager.projectCreator",
    "roles/resourcemanager.folderViewer"
  ])
  role   = each.key
  member = "serviceAccount:${google_service_account.tfc_service_account.email}"
}

resource "google_billing_account_iam_member" "tfc_sa_billing_account_member" {
  billing_account_id = var.billing_account_id
  role               = "roles/billing.user"
  member             = "serviceAccount:${google_service_account.tfc_service_account.email}"
}

# projects

/* resource "google_project" "osakunta-website" {
 name            = "Website Prod"
  project_id      = "osakunta-website-prod"
  org_id          = data.google_project.foundation_project.org_id
  billing_account = var.billing_account_id
}
  */
