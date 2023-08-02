locals {
  project_id = "resource-label-checker"
  region     = "asia-northeast1"

  cloudrun_service_account_id       = "rlc-cloudrun"
  cloudscheduler_service_account_id = "rlc-cloudscheduler"

  artifactregistry_image_url = "asia-northeast1-docker.pkg.dev/resource-label-checker-shared/resource-label-checker/resource-label-checker"
}