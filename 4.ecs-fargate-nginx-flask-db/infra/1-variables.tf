variable "vpc_cidr" {
  description = "CIDR block for main"
  type        = string
  default     = "10.0.0.0/16"
}

variable "env" {
  type    = string
  default = "development"
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "availability_zones" {
  type    = string
  default = "us-east-1a"
}

variable "app_name" {
  type    = string
  default = "sample-ecs-fargate-app"
}

variable "ecs_auto_scale_role_name" {
  description = "ECS auto scale role name"
  default     = "myEcsAutoScaleRole"
}
