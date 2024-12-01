resource "aws_ecs_task_definition" "shomotsu_development_task_definition" {
  container_definitions    = jsonencode(
    [
      {
          command          = [
            "php artisan cache:clear && php artisan config:clear && php artisan config:cache && php artisan view:cache && php artisan route:cache && chown -hR laravel:laravel storage bootstrap/cache && php artisan migrate:refresh --seed --force && php-fpm && composer install --optimize-autoloader --no-dev",
          ]
          entryPoint       = [
            "sh",
            "-c",
          ]
          environmentFiles = [
            {
              type  = "s3"
              value = "arn:aws:s3:::test-repository-bucket/.env"
            },
          ]
          secrets     = var.secrets
          essential        = true
          image            = "637423419750.dkr.ecr.ap-northeast-1.amazonaws.com/test-repository-laravel:development.v0.0.0098"
          logConfiguration = {
            logDriver     = "awslogs"
            options       = {
              awslogs-create-group  = "true"
              awslogs-group         = "/ecs/${var.family_name}"
              awslogs-region        = "ap-northeast-1"
              awslogs-stream-prefix = "ecs"
            }
          }
          name             = "shomotsu_development_laravel_repository"
          portMappings     = [
            {
              containerPort = 9000
              hostPort      = 9000
              name          = "shomotsu_development_laravel_repository-9000-tcp"
              protocol      = "tcp"
            },
          ]
          workingDirectory = "/var/www/html"
      },
      {
          essential        = true
          image            = "637423419750.dkr.ecr.ap-northeast-1.amazonaws.com/test-repository-nginx:development.v0.0.0098"
          logConfiguration = {
            logDriver     = "awslogs"
            options       = {
                awslogs-create-group  = "true"
                awslogs-group         = "/ecs/${var.family_name}"
                awslogs-region        = "ap-northeast-1"
                awslogs-stream-prefix = "ecs"
            }
          }
          name             = "test-repository-nginx"
          portMappings     = [
            {
              appProtocol   = "http"
              containerPort = 80
              hostPort      = 80
              name          = "test-repository-nginx-80-tcp"
              protocol      = "tcp"
            },
          ]
          volumesFrom      = [
            {
              readOnly        = false
              sourceContainer = "shomotsu_development_laravel_repository"
            },
          ]
      },
    ]
  )
  cpu                      = "1024"
  execution_role_arn       = "arn:aws:iam::637423419750:role/ecsTaskExecutionRole"
  family                   = var.family_name
  ipc_mode                 = null
  memory                   = "3072"
  network_mode             = "awsvpc"
  pid_mode                 = null
  requires_compatibilities = [
    "FARGATE",
  ]
  track_latest = true
  tags                     = var.tags
  task_role_arn            = "arn:aws:iam::637423419750:role/ECStoS3"

  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
}