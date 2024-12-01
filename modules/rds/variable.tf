variable "apply_immediately" {
  default = true
}
variable "allocated_storage" {}
variable "backup_retention_period" {
  default = 0
}
variable "monitoring_interval" {
  default = 0
}
variable performance_insights_retention_period {
  default = 0
}
variable "storage_type" {}
variable "engine" {}
variable "engine_version" {}
variable "identifier" {}
variable "instance_class" {}
variable "username" {}
variable "manage_master_user_password" {}
variable "skip_final_snapshot" {
  default= true
}
variable "rds_sg_id" {}
variable "subnet_id" {}
variable "tags" {
  
}

variable "db_name" {
  
}