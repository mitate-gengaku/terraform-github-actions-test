variable "vpc_id" {}
variable "public_subnets" {
  default = {
    "subnet-1" = {
      availability_zone = "ap-northeast-1a",
      cidr_block        = "10.0.0.0/20",
      tag_name          = "shomotsu_development_public-1a"
    },
    "subnet-2" = {
      availability_zone = "ap-northeast-1c"
      cidr_block        = "10.0.16.0/20",
      tag_name          = "shomotsu_development_public-1c"
    },
    "subnet-3" = {
      availability_zone = "ap-northeast-1d"
      cidr_block        = "10.0.32.0/20",
      tag_name          = "shomotsu_development_public-1d"
    }
  }  
}
variable "private_subnets" {
  default = {
    "shomotsu_development_private-1a" = {
      availability_zone = "ap-northeast-1a",
      cidr_block        = "10.0.128.0/20",
      tag_name          = "shomotsu_development_private-1a"
    },
    "shomotsu_development_private-1c" = {
      availability_zone = "ap-northeast-1c"
      cidr_block        = "10.0.144.0/20",
      tag_name          = "shomotsu_development_private-1c"
    },
    "shomotsu_development_private-1d" = {
      availability_zone = "ap-northeast-1d"
      cidr_block        = "10.0.160.0/20",
      tag_name          = "shomotsu_development_private-1d"
    }
  }
}
variable "env" {}