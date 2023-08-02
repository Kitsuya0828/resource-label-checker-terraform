locals {
  project_id = "resource-label-checker-shared"
  region     = "asia-northeast1"

  service_account_id                 = "github-actions"
  workload_identity_pool_id          = "github-actions"
  workload_identity_pool_provider_id = "github-actions-provider"

  artifactregistry_repository_id = "resource-label-checker"

  github_repository_name = "Kitsuya0828/resource-label-checker"
}