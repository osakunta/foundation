resource "google_folder" "osakunta_folder" {
  display_name = "osakunta"
  parent       = "organizations/${data.google_project.foundation_project.org_id}"
}

moved {
  from = google_folder.osakunta-folder
  to   = google_folder.osakunta_folder
}
moved {
  from = google_project.osakunta-website-prod
  to   = google_project.osakunta_website_prod
}
moved {
  from = google_project_service.osakunta-website-prod-services
  to   = google_project_service.osakunta_website_prod_services
}
