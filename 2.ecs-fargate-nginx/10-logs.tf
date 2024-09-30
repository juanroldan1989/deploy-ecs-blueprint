# Set up CloudWatch group and log stream and retain logs for 30 days
resource "aws_cloudwatch_log_group" "cb_log_group" {
  name              = "/ecs/log-group/${var.app_name}/${var.env}"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_stream" "cb_log_stream" {
  name           = "/ecs/log-stream/${var.app_name}/${var.env}"
  log_group_name = aws_cloudwatch_log_group.cb_log_group.name
}
