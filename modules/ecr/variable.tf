variable "repositories" {
  default = {
    "nginx" = {
      image_tag_mutability = "IMMUTABLE"
      name                 = "shomotsu_development_nginx_repository"
      registry_id          = "637423419750"
      repository_url       = "637423419750.dkr.ecr.ap-northeast-1.amazonaws.com/shomotsu_development_nginx_repository"
      tags                 = {
        Name = "shomotsu_development_nginx_repository"
        Environment = "development"
      }

      image_scanning_configuration = {
        scan_on_push = true
      }
    }
    "laravel" = {
      image_tag_mutability = "IMMUTABLE"
      name                 = "shomotsu_development_laravel_repository"
      registry_id          = "637423419750"
      repository_url       = "637423419750.dkr.ecr.ap-northeast-1.amazonaws.com/shomotsu_development_laravel_repository"
      tags                 = {
        Name = "shomotsu_development_laravel_repository"
        Environment = "development"
      }

      image_scanning_configuration = {
        scan_on_push = true
      }
    }
  }
}