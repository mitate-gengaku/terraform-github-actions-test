variable "vpc_id" {}
variable "security_groups" {
  default = {
    "ecs" = {
      description = "Security group for ECS"
      name        = "ECS_of_Shomotsu"
      name_prefix = null
      tags        = {
        Environment = "development"
      }
    },
    "alb" = {
      description = "Security group for ALB"
      name        = "ALB_of_Shomotsu"
      name_prefix = null
      tags        = {
        Environment = "development"
      }
    },
    "rds" = {
      description = "Security group for RDS"
      name        = "RDS_of_Shomotsu"
      name_prefix = null
      tags        = {
        Environment = "development"
      }
    },
    "elasticache" = {
      description = "Security group for ElastiCache"
      name        = "ElastiCache_of_Shomotsu"
      name_prefix = null
      tags        = {
        Environment = "development"
      }
    }
  }
}