# Deploy ECS Blueprint

Reference: https://spacelift.io/blog/terraform-ecs

## [ECS (FARGATE) Nginx](https://github.com/juanroldan1989/deploy-ecs-blueprint/tree/main/2.ecs-fargate-nginx)

### Service AutoScaling

![Screenshot 2024-09-27 at 20 56 26](https://github.com/user-attachments/assets/863f879d-0460-4e1e-b03c-db883ea49283)

## [ECS (FARGATE) Nginx + WSGI + Flask App](https://github.com/juanroldan1989/deploy-ecs-blueprint/tree/main/3.ecs-fargate-nginx-flask)

![Screenshot 2024-09-30 at 12 28 13](https://github.com/user-attachments/assets/20bef5c8-8723-40b9-92be-be8427a8ee5e)

- Pipeline integrated within `Github Actions`
- Infrastructure provisioned through `Terraform`
- Load Testing performed through `wrk` on all endpoints

## Showcase ECS Working modes

- EC2: Scenarios where works best. Pros & Cons.
- FARGATE: Scenarios where works best. Pros & Cons.

## Showcase ECS Service/Task adjustments for different applications

1. Single Python App without database.
2. Single Python App with database.

## Build Pipeline

1. Changes are pushed into `main` branch (via pull-request)
2. `ECR` is created if it doesn't exist already.

```ruby
resource "aws_ecr_repository" "image_repo" {
  name                 = var.name
  image_tag_mutability = "IMMUTABLE"
  encryption_configuration {
    encryption_type = "KMS"
    kms_key         = aws_kms_key.custom_kms_key.arn
  }

  image_scanning_configuration {
    scan_on_push = true
  }
}
```

3. Docker `build` is triggered.
4. New Docker image is `tagged` and `pushed`.
5. `terraform apply` command is triggered using new `IMAGE_TAG` - https://skundunotes.com/2024/05/06/continuous-deployment-of-amazon-ecs-service-using-terraform-and-github-actions/

## Setup Terraform `backend`

https://github.com/kunduso/add-aws-ecr-ecs-fargate/blob/main/deploy/backend.tf

```
terraform {
  backend "s3" {
    bucket  = "kunduso-terraform-remote-bucket"
    encrypt = true
    key     = "tf/add-aws-ecr-ecs-fargate/deploy-ecs.tfstate"
    region  = "us-east-2"
  }
}
```

## Chaos Engineering

https://medium.com/aws-arena/aws-fargate-chaos-monkey-78faa8923af6
