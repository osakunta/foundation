
resource "google_project" "osakunta_website_prod" {
  name            = "Website prod"
  project_id      = "osakunta-website-prod"
  billing_account = var.billing_account_id
  folder_id       = google_folder.osakunta_folder.id

  labels = {
    team        = "osakunta"
    environment = "prod"
  }
  depends_on = [google_project_service.services]
}


resource "google_project_service" "osakunta_website_prod_services" {
  project = google_project.osakunta_website_prod.project_id

  for_each = toset([
    "run.googleapis.com",
  ])

  service = each.key
}

// osakunta website prod tfc service account

resource "google_service_account" "osakunta_website_prod_cicd_sa" {
  account_id   = "osakunta-website-prod-cicd-sa"
  display_name = "Osakunta Website Prod CI/CD Service Account"
}

resource "google_service_account_iam_member" "osakunta_website_prod_cicd_sa_member" {
  service_account_id = google_service_account.osakunta_website_prod_cicd_sa.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.tfc_pool.name}/attribute.workspace_id/ws-gNGfFerRSizkFewd"
}

output "osakunta_website_prod_project_id" {
  value = google_project.osakunta_website_prod.project_id
}

# wordpress cloud run service
# resource "google_cloud_run_v2_service" "osakunta-website-wordpress" {
#   name     = "osakunta-website-service"
#   location = "europe-north1"
#   project  = google_project.osakunta-website-prod.project_id

#   template {
#     containers {
#       image = "gcr.io/osakunta-website-prod/wordpress:latest"

#       resources {
#         limits = {
#           memory = "512Mi"
#           cpu    = "1"
#         }
#       }

#       env {
#         name  = "WORDPRESS_DB_HOST"
#         value = google_sql_database_instance.osakunta-website-sql-instance.connection_name
#       }

#       env {
#         name  = "WORDPRESS_DB_USER"
#         value = google_sql_user.osakunta-website-sql-user.name
#       }

#       env {
#         name  = "WORDPRESS_DB_PASSWORD"
#         value = random_password.osakunta-website-db-password.result
#       }

#       env {
#         name  = "WORDPRESS_DB_NAME"
#         value = google_sql_database.osakunta-website-sql-database.name
#       }
#     }

#     service_account = google_service_account.osakunta-website-service-account.email
#   }

#   traffic {
#     percent         = 100
#     latest_revision = true
#   }

#   depends_on = [google_project_service.osakunta-website-prod-services]
# }
