output "route_table_id" {
  value = aws_route_table.shomotsu_development_public_route_table.id
}

output "public_route_tables" {
  value = aws_route_table.shomotsu_development_public_route_table
}

output "private_route_tables" {
  value = aws_route_table.shomotsu_development_private_route_table
}