resource "aws_ecs_service" "ecs_service" {
  name            = "my-ecs-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task_definition.arn
  desired_count   = 2

  network_configuration {
    subnets         = [aws_subnet.subnet.id, aws_subnet.subnet2.id]
    security_groups = [aws_security_group.security_group.id]
  }

  force_new_deployment = true

  # We have specified that the container instances should run on distinct instances
  # instead of using the residual capacity in each instance.
  # This is not a best practice, but just to prove the concept.
  placement_constraints {
    type = "distinctInstance"
  }

  # When expanding the plan for aws_ecs_service.ecs_service to include new values learned so far during apply,
  # provider "registry.terraform.io/hashicorp/aws" produced an invalid new value for .triggers["redeployment"]:
  # triggers = {
  #   redeployment = timestamp()
  # }

  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.ecs_capacity_provider.name
    weight            = 100
  }

  # Registering multiple target groups with an Amazon ECS service
  # https://docs.aws.amazon.com/AmazonECS/latest/developerguide/register-multiple-targetgroups.html
  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_tg.arn
    container_name   = "nginx"
    container_port   = 80
  }

  depends_on = [aws_autoscaling_group.ecs_asg]
}
