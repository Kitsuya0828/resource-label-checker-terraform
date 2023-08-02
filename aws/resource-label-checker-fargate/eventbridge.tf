data "aws_iam_policy_document" "scheduler_policy_document" {
  version = "2012-10-17"
  statement {
    actions = [
      "ecs:RunTask"
    ]
    resources = [
      aws_ecs_task_definition.default.arn,
      aws_ecs_task_definition.default.arn_without_revision,
    ]
  }
  statement {
    actions = [
      "iam:PassRole"
    ]
    resources = ["*"]
    condition {
      test     = "StringLike"
      variable = "iam:PassedToService"
      values   = ["ecs-tasks.amazonaws.com"]
    }
  }
}


resource "aws_iam_role" "scheduler_role" {
  name = "resource-label-checker-fargate-scheduler-role"

  inline_policy {
    name   = "permissions"
    policy = data.aws_iam_policy_document.scheduler_policy_document.json
  }

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole"
        ]
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "scheduler.amazonaws.com"
        }
      },
    ]
  })
}



resource "aws_scheduler_schedule" "default" {
  name       = "resource-label-checker"
  group_name = "default"

  flexible_time_window {
    mode = "OFF"
  }
  schedule_expression_timezone = "Asia/Tokyo"
  #   schedule_expression          = "rate(10 minutes)" # for debugging
  schedule_expression = "cron(* 10 ? * 1-5 *)"

  target {
    arn      = aws_ecs_cluster.default.arn
    role_arn = aws_iam_role.scheduler_role.arn

    ecs_parameters {
      task_definition_arn = aws_ecs_task_definition.default.arn_without_revision
      launch_type         = "FARGATE"
      platform_version    = "LATEST"
      network_configuration {
        subnets = [aws_subnet.private.id]
      }
    }
  }
}