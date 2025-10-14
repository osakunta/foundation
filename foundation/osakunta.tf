resource "google_folder" "osakunta_folder" {
  display_name = "osakunta"
  parent       = "organizations/${data.google_project.foundation_project.org_id}"
}
