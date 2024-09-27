terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~>2.20.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.60.0"
    }
  }
}

provider "docker" {}

provider "aws" {
  region = var.aws_region

  shared_config_files      = ["/Users/juan/.aws/config"]
  shared_credentials_files = ["/Users/juan/.aws/credentials"]
  profile                  = "default"

  default_tags {
    tags = {
      owner       = "Juan Roldan"
      project     = "AWS ECS Cluster"
      cost-center = "AWS ECS Billing"
      environment = var.env
      app_name    = var.app_name
      Name        = "Managed by Terraform"
    }
  }
}
