resource "aws_ecr_repository" "default" {
  name = "resource-label-checker-lambda"

  image_scanning_configuration {
    scan_on_push = true
  }
  force_delete = true
}