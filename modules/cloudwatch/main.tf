resource "aws_cloudwatch_log_group" "shomotsu_development_log_group" {
  name = "/ecs/${var.name}"
}