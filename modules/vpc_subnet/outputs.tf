output "public_subnets" {
  value = aws_subnet.shomotsu_development_public_subnets
}

output "private_subnets" {
  value = aws_subnet.shomotsu_development_private_subnets
}