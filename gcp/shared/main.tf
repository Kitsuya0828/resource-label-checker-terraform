# Workload identity federation
resource "google_service_account" "github_actions" {
  account_id = local.service_account_id
}

resource "google_project_iam_member" "github_actions" {
  project = local.project_id
  role    = "roles/artifactregistry.writer"
  member  = "serviceAccount:${google_service_account.github_actions.email}"
}

resource "google_iam_workload_identity_pool" "github_actions" {
  workload_identity_pool_id = local.workload_identity_pool_id
}

resource "google_iam_workload_identity_pool_provider" "github_actions" {
  workload_identity_pool_provider_id = local.workload_identity_pool_provider_id
  workload_identity_pool_id          = google_iam_workload_identity_pool.github_actions.workload_identity_pool_id

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }

  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.repository" = "assertion.repository"
    "attribute.actor"      = "assertion.actor"
  }
}

resource "google_service_account_iam_member" "github_actions_iam_workload_identity_user" {
  service_account_id = google_service_account.github_actions.id
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/projects/${data.google_project.default.number}/locations/global/workloadIdentityPools/${local.workload_identity_pool_id}/attribute.repository/${local.github_repository_name}"
}


# Artifact Registry
resource "google_artifact_registry_repository" "default" {
  location      = local.region
  repository_id = local.artifactregistry_repository_id
  description   = "docker repository for resource-label-checker"
  format        = "DOCKER"
}