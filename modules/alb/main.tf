resource "aws_alb" "alb" {
  name = var.name
  internal = var.internal
  load_balancer_type = "application"

  security_groups = var.security_groups
  subnets = var.subnets
}