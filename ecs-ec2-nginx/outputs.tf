output "alb_dns_name" {
  description = "ALB DNS Name"
  value       = aws_alb.ecs_alb.dns_name
}
