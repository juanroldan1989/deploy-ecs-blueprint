resource "aws_ecs_service" "ecs_service" {
  name            = "my-ecs-fargate-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task_definition.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.subnet.id, aws_subnet.subnet2.id]
    security_groups  = [aws_security_group.security_group.id]
    assign_public_ip = true
  }

  force_new_deployment = true

  # Registering multiple target groups with an Amazon ECS service
  # https://docs.aws.amazon.com/AmazonECS/latest/developerguide/register-multiple-targetgroups.html
  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_tg.arn
    container_name   = "nginx"
    container_port   = 80
  }

  depends_on = [aws_lb_listener.ecs_alb_listener]
}
