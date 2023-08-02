resource "aws_ecr_repository" "default" {
  name = "resource-label-checker-fargate"

  image_scanning_configuration {
    scan_on_push = true
  }
  force_delete = true
}