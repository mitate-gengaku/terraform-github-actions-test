output "rds_endpoint" {
  value = "${aws_db_instance.shomotsu_development_mysql_db.endpoint}"
}

output "aws_rds_db_password_arn" {
  value = data.aws_ssm_parameter.dbpassword.arn
}

output "rds_username_ssm" {
  value = aws_ssm_parameter.rds_username_parameter.arn
}

output "rds_dbname_ssm" {
  value = aws_ssm_parameter.rds_dbname_parameter.arn
}

output "rds_host_ssm" {
  value = aws_ssm_parameter.rds_parameter.arn
}