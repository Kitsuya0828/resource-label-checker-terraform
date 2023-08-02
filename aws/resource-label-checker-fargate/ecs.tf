resource "aws_cloudwatch_log_group" "default" {
  name              = "/ecs/resource-label-checker-fargate"
  retention_in_days = 3
}

resource "aws_ecs_task_definition" "default" {
  family = "resource-label-checker-fargate"
  container_definitions = jsonencode([
    {
      name  = "resource-label-checker-fargate"
      image = aws_ecr_repository.default.repository_url
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-region : local.region
          awslogs-group : aws_cloudwatch_log_group.default.name
          awslogs-stream-prefix : "ecs"
        }
      }
      environment = [
        {
          name  = "REGION"
          value = local.region
        },
        {
          name  = "ACCOUNT_NAME"
          value = local.account_name
        },
        # SLACK_TOKEN and SLACK_CHANNEL_ID should be edited directly on the console
        {
          name  = "SLACK_TOKEN"
          value = "xoxb-xxxx-xxxx-xxxx"
        },
        {
          name  = "SLACK_CHANNEL_ID"
          value = "XXXXXX"
        }
      ]
      cpu    = 256
      memory = 512
    },
  ])
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  task_role_arn            = aws_iam_role.ecs_role.arn
  execution_role_arn       = aws_iam_role.ecs_role.arn
  
  lifecycle {
    ignore_changes = [ container_definitions ]
  }

  depends_on = [aws_ecr_repository.default]
}

resource "aws_ecs_cluster" "default" {
  name = "resource-label-checker-fargate"
}

resource "aws_ecs_cluster_capacity_providers" "default" {
  cluster_name       = aws_ecs_cluster.default.name
  capacity_providers = ["FARGATE", "FARGATE_SPOT"]
}

resource "aws_iam_role" "ecs_role" {
  name = "resource-label-checker-fargate-ecs-role"

  inline_policy {
    name   = "permissions"
    policy = data.aws_iam_policy_document.ecs_policy_document.json
  }

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"]
}

data "aws_iam_policy_document" "ecs_policy_document" {
  version = "2012-10-17"
  statement {
    actions = [
      "config:ListDiscoveredResources",
      "config:BatchGetResourceConfig"
    ]
    resources = [
      "*"
    ]
  }
}