provider "google" {
  project = local.project_id
  region  = local.region
}

data "google_project" "default" {
}