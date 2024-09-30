# Deploy ECS Blueprint

Reference: https://spacelift.io/blog/terraform-ecs

- List of components to be deployed
- Steps for deployment
- Blueprint should work with any Docker Image

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

# Load Testing results

```
$ brew install wrk
```

```ruby
$ wrk -t4 -c1000 -d60s http://ecs-alb-1948815992.us-east-1.elb.amazonaws.com/
Running 1m test @ http://ecs-alb-1948815992.us-east-1.elb.amazonaws.com/
  4 threads and 1000 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency   133.31ms   67.79ms 952.37ms   93.81%
    Req/Sec   357.66    160.09   666.00     65.64%
  82281 requests in 1.00m, 66.93MB read
  Socket errors: connect 754, read 0, write 0, timeout 0
Requests/sec:   1370.80
Transfer/sec:      1.12MB
```

```
$ wrk -t4 -c10000 -d60s http://ecs-alb-1948815992.us-east-1.elb.amazonaws.com/
Running 1m test @ http://ecs-alb-1948815992.us-east-1.elb.amazonaws.com/
  4 threads and 10000 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency   133.73ms   66.60ms 882.47ms   92.01%
    Req/Sec   374.00    297.19     1.01k    65.79%
  80857 requests in 1.00m, 65.78MB read
  Socket errors: connect 9754, read 0, write 0, timeout 0
Requests/sec:   1345.29
Transfer/sec:      1.09MB
```

# AWS ECS (FARGATE)

## Force Task replacement

- Approach 1:

```
$ terraform apply --auto-approve -replace="aws_ecs_task_definition.custom_nginx_flask_task"
```

- Approach 2:
  https://github.com/hashicorp/terraform-provider-aws/issues/13528#issuecomment-797631866

## AutoScaling

![Screenshot 2024-09-27 at 20 56 26](https://github.com/user-attachments/assets/863f879d-0460-4e1e-b03c-db883ea49283)

## Chaos Engineering

https://medium.com/aws-arena/aws-fargate-chaos-monkey-78faa8923af6
