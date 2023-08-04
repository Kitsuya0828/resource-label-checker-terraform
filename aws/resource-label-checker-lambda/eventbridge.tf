resource "aws_cloudwatch_event_rule" "default" {
  name                = "resouce-label-checker-lambda"
  schedule_expression = "cron(0 1 ? * 2-6 *)"
}

resource "aws_cloudwatch_event_target" "default" {
  rule      = aws_cloudwatch_event_rule.default.name
  arn       = aws_lambda_function.default.arn
  target_id = "lambda"
}