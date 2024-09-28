resource "aws_ecs_task_definition" "custom_nginx_flask_task" {
  family                   = "custom-nginx-flask-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = "arn:aws:iam::542979624611:role/ecsTaskExecutionRole"
  cpu                      = 512
  memory                   = 1024

  # hard-coding definitions since encoding multiple container definitions is troublesome for the time being
  container_definitions = jsonencode([
    {
      name        = "custom-nginx"
      image       = "juanroldan1989/custom-nginx:latest"
      cpu         = 128
      memory      = 256
      essential   = true
      networkMode = "awsvpc"
      command     = ["/app/start.sh"]
      environment = [
        { "name" : "FLASK_SERVER_ADDR", "value" : "flask-app:8000" }
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
      command     = ["gunicorn -w 3 -t 60 -b 0.0.0.0:8000 app:app"]
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
    }
  ])

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}
