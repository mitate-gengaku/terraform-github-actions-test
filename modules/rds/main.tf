resource "aws_db_instance" "shomotsu_development_mysql_db" {
  apply_immediately = var.apply_immediately
  allocated_storage = var.allocated_storage
  backup_retention_period = var.backup_retention_period
  monitoring_interval = var.monitoring_interval

  performance_insights_retention_period = var.performance_insights_retention_period
  storage_type = var.storage_type
  engine = var.engine
  engine_version = var.engine_version
  identifier = var.identifier
  instance_class = var.instance_class
  username       = var.username
  password = data.aws_ssm_parameter.dbpassword.value
  skip_final_snapshot = var.skip_final_snapshot
  vpc_security_group_ids = [
    var.rds_sg_id
  ]
  db_name = aws_ssm_parameter.rds_dbname_parameter.value
  db_subnet_group_name = var.subnet_id
  tags = var.tags
}

data "aws_ssm_parameter" "dbpassword" {
  name = var.dbpassword_name
}

resource "aws_ssm_parameter" "rds_username_parameter" {
  name = var.rds_username_paramete_name

  type = "String"
  value = var.username
}

resource "aws_ssm_parameter" "rds_dbname_parameter" {
  name = var.rds_dbname_parameter_name

  type = "String"
  value = var.db_name
}

resource "aws_ssm_parameter" "rds_parameter" {
  name = var.rds_parameter_name

  type = "String"
  value = aws_db_instance.shomotsu_development_mysql_db.endpoint
}