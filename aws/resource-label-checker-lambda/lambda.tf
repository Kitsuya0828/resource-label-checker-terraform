data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "lambda_policy_document" {
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
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"
  inline_policy {
    name   = "permissions"
    policy = data.aws_iam_policy_document.lambda_policy_document.json
  }
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_lambda_function" "default" {
  function_name = "resource-label-checker-lambda"
  role          = aws_iam_role.iam_for_lambda.arn
  package_type  = "Image"

  image_uri = "${aws_ecr_repository.default.repository_url}:latest"
  timeout   = 60 * 15

  environment {
    variables = {
      REGION           = local.region
      ACCOUNT_NAME     = local.account_name
      SLACK_TOKEN      = "xoxb-xxxx-xxxx-xxxx"
      SLACK_CHANNEL_ID = "XXXXXXXXX"
    }
  }
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.default.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.default.arn
}