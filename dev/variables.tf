variable "aws_account_id" {
  type = string
}

variable "shomotsu_acm_id" {
  type = string
}

variable "image_acm_domain" {
  type = string
}

variable "dbpassword_name" {
  type = string
}

variable "db_name" {
  type = string
}

variable "rds_username_paramete_name" {
  type = string
}

variable "rds_dbname_parameter_name" {
  type = string
}

variable "rds_parameter_name" {
  type = string
}

variable "route53_domain_name" {
  type = string
}

variable "bucket_source_arn" {
  type = string
}

variable "env_s3" {
  type = string
}

variable "laravel_container_image" {
  type = string
}

variable "nginx_container_image" {
  type = string
}

variable "execution_role_arn" {
  type = string
}

variable "task_role_arn" {
  type = string
}