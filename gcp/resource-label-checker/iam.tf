# Cloud Run
resource "google_service_account" "cloudrun" {
  account_id = local.cloudrun_service_account_id
}

resource "google_project_iam_member" "cloudrun" {
  project = local.project_id
  role    = "roles/cloudasset.viewer"
  member  = google_service_account.cloudrun.member
}

# Cloud Scheduler
resource "google_service_account" "cloudscheduler" {
  account_id = local.cloudscheduler_service_account_id
}

resource "google_project_iam_member" "cloudscheduler" {
  project = local.project_id
  role    = "roles/run.invoker"
  member  = google_service_account.cloudscheduler.member
}