output "elasticache_endpoint" {
  // value = aws_elasticache_serverless_cache.shomotsu_development_elasticache_cluster.endpoint
  value = aws_ssm_parameter.elasticache_host.value
}