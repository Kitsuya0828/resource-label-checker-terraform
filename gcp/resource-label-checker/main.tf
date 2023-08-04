# Cloud Run
resource "google_cloud_run_v2_job" "default" {
  name     = "resource-label-checker"
  location = local.region

  template {
    template {
      containers {
        image = local.artifactregistry_image_url
        env {
          name  = "PROJECT_ID"
          value = local.project_id
        }
        # SLACK_TOKEN and SLACK_CHANNEL_ID should be edited directly on the console
        env {
          name  = "SLACK_TOKEN"
          value = "xoxb-xxxx-xxxx-xxxx"
        }
        env {
          name  = "SLACK_CHANNEL_ID"
          value = "XXXXXX"
        }
      }
      service_account = google_service_account.cloudrun.email
      max_retries     = 1       # default is 3
      timeout         = "3600s" # default is "10min"
    }
  }
  lifecycle {
    ignore_changes = [
      template[0].template[0].containers[0].env[1],
      template[0].template[0].containers[0].env[2],
    ]
  }

  depends_on = [google_service_account.cloudrun]
}

# Cloud Scheduler
resource "google_cloud_scheduler_job" "job" {
  name             = "resource-label-checker"
  schedule         = "0 10 * * 1-5"
  time_zone        = "Asia/Tokyo"
  attempt_deadline = "30s"

  http_target {
    http_method = "POST"
    uri         = "https://${google_cloud_run_v2_job.default.location}-run.googleapis.com/apis/run.googleapis.com/v1/namespaces/${data.google_project.default.number}/jobs/${google_cloud_run_v2_job.default.name}:run"

    oauth_token {
      service_account_email = google_service_account.cloudscheduler.email
    }
  }
  depends_on = [google_service_account.cloudscheduler]
}