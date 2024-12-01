resource "aws_ecs_service" "service" {
  name          = var.name
  cluster       = var.cluster_id
  desired_count = 1
  launch_type   = "FARGATE"

  network_configuration {
    subnets = var.public_subnets
    security_groups  = var.security_groups
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name = "test-repository-nginx"
    container_port = 80
  }

  task_definition = var.task_definition_arn
  tags = var.tags
}