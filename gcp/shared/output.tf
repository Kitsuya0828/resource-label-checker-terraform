output "workload_identity_pool_provider_name" {
  value = google_iam_workload_identity_pool_provider.github_actions.name
}

output "artifact_registry_repository_id" {
  value = google_artifact_registry_repository.default.id
}

output "service_account_email" {
  value = google_service_account.github_actions.email
}