data "template_file" "cb_app" {
  template = file("./templates/app.json.tpl")

  vars = {
    app_name       = "nginx"
    app_image      = "public.ecr.aws/nginx/nginx:1.27.1-alpine3.20-perl"
    fargate_cpu    = 256
    fargate_memory = 256
    essential      = true
    app_port       = 80
    aws_log_group  = "/ecs/log-group/${var.app_name}/${var.env}"
    aws_region     = var.aws_region
  }
}

resource "aws_ecs_task_definition" "ecs_task_definition" {
  family                   = "my-ecs-fargate-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = "arn:aws:iam::542979624611:role/ecsTaskExecutionRole"
  cpu                      = 256
  memory                   = 512
  container_definitions    = data.template_file.cb_app.rendered

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}
