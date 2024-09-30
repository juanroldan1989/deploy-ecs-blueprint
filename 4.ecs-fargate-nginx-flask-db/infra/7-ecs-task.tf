resource "aws_ecs_task_definition" "custom_nginx_flask_task" {
  family                   = "custom-nginx-flask-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = "arn:aws:iam::542979624611:role/ecsTaskExecutionRole"
  cpu                      = 512
  memory                   = 1024

  container_definitions = jsonencode([
    {
      name        = "custom-nginx"
      image       = "juanroldan1989/custom-nginx:latest"
      cpu         = 128
      memory      = 256
      essential   = true
      networkMode = "awsvpc"
      dependsOn = [
        { "containerName" : "flask-app", "condition" : "HEALTHY" },
        { "containerName" : "db", "condition" : "HEALTHY" }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/log-group/${var.app_name}/${var.env}/custom-nginx"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    },
    {
      name        = "flask-app"
      image       = "juanroldan1989/flask-app:latest"
      cpu         = 128
      memory      = 256
      essential   = true
      networkMode = "awsvpc"
      environment = [
        { "name" : "DB_HOST", "value" : "db" },
        { "name" : "DB_USER", "value" : "root" },
        { "name" : "DB_NAME", "value" : "example" },
      ]
      healthCheck = {
        command     = ["CMD-SHELL", "curl --silent --fail http://localhost:8000/flask-health-check || exit 1"]
        interval    = 10
        retries     = 3
        timeout     = 10
        startPeriod = 30
      }
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/log-group/${var.app_name}/${var.env}/flask-app"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
      portMappings = [
        {
          containerPort = 8000
          hostPort      = 8000
        }
      ]
    },
    {
      # TODO: implement KMS to provision DB password
      # { "name" : "MYSQL_ROOT_PASSWORD_FILE", "value" : "${aws::resource::kms}" }
      name        = "db"
      image       = "mariadb:10-focal"
      cpu         = 128
      memory      = 256
      essential   = true
      command     = ["--default-authentication-plugin=mysql_native_password"]
      networkMode = "awsvpc"
      environment = [
        { "name" : "MYSQL_DATABASE", "value" : "example" },
        { "name" : "MYSQL_ROOT_PASSWORD", "value" : "db-78n9n" }
      ]
      healthCheck = {
        command     = ["CMD-SHELL", "mysqladmin ping -h 127.0.0.1 --password='db-78n9n' --silent || exit 1"]
        interval    = 10
        retries     = 3
        timeout     = 10
        startPeriod = 30
      }
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/log-group/${var.app_name}/${var.env}/db"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
      portMappings = [
        {
          containerPort = 3306
          hostPort      = 3306
        },
        {
          containerPort = 33060
          hostPort      = 33060
        }
      ]
    }
  ])

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}
