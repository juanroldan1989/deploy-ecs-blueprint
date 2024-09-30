resource "aws_cloudwatch_log_group" "custom_nginx_log_group" {
  name              = "/ecs/log-group/${var.app_name}/${var.env}/custom-nginx"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_stream" "custom_nginx_log_stream" {
  name           = "/ecs/log-stream/${var.app_name}/${var.env}/custom-nginx"
  log_group_name = aws_cloudwatch_log_group.custom_nginx_log_group.name
}

resource "aws_cloudwatch_log_group" "flask_app_log_group" {
  name              = "/ecs/log-group/${var.app_name}/${var.env}/flask-app"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_stream" "flask_app_log_stream" {
  name           = "/ecs/log-stream/${var.app_name}/${var.env}/flask-app"
  log_group_name = aws_cloudwatch_log_group.flask_app_log_group.name
}

resource "aws_cloudwatch_log_group" "db_log_group" {
  name              = "/ecs/log-group/${var.app_name}/${var.env}/db"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_stream" "db_log_stream" {
  name           = "/ecs/log-stream/${var.app_name}/${var.env}/db"
  log_group_name = aws_cloudwatch_log_group.db_log_group.name
}
