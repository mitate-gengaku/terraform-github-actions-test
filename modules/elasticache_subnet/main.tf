resource "aws_elasticache_subnet_group" "shomotsu_development_elasticache_subnet_group" {
  name = var.name
  description = var.description
  subnet_ids = var.subnet_ids

  tags = var.tags
}