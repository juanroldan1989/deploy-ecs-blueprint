<img src="https://github.com/juanroldan1989/deploy-ecs-blueprint/blob/main/aws-ecs-logo.png" alt="juanroldan1989 ecs-deploy-blueprint">

<h4 align="center">Github Actions integration | Docker images build/tag/push worklows | Infrastructure by Terraform </h4>

<p align="center">
  <a href="https://github.com/juanroldan1989/deploy-ecs-blueprint/commits/main">
  <img src="https://img.shields.io/github/last-commit/juanroldan1989/deploy-ecs-blueprint.svg?style=flat-square&logo=github&logoColor=white" alt="GitHub last commit">
  <a href="https://github.com/juanroldan1989/deploy-ecs-blueprint/issues">
  <img src="https://img.shields.io/github/issues-raw/juanroldan1989/deploy-ecs-blueprint.svg?style=flat-square&logo=github&logoColor=white" alt="GitHub issues">
  <a href="https://github.com/juanroldan1989/deploy-ecs-blueprint/pulls">
  <img src="https://img.shields.io/github/issues-pr-raw/juanroldan1989/deploy-ecs-blueprint.svg?style=flat-square&logo=github&logoColor=white" alt="GitHub pull requests">
  <a href="https://github.com/juanroldan1989/deploy-ecs-blueprint/blob/main/LICENSE">
    <img src="https://img.shields.io/badge/license-MIT-brightgreen.svg">
  </a>
</p>

<p align="center">
  <a href="#aws_key_components">AWS Key Components</a> •
  <a href="#project_workflow">Project Workflow</a> •
  <a href="#pricing">Pricing</a> •
  <a href="#blueprints">Blueprints</a> •
  <a href="#further_improvements">Further Improvements</a> •
  <a href="#references">References</a>  •
  <a href="#contribute">Contribute</a>
</p>

# AWS Key Components

Each project code leverages these **AWS** services through **Terraform** to create an automated deployment pipeline for your application, ensuring scalability, reliability, and security throughout the process.

1. **Amazon Virtual Private Cloud (VPC):** Is a secure, isolated private cloud hosted.
2. **Amazon Subnets:** Public and private subnets within the VPC for isolating resources based on security requirements.
3. **Amazon Internet Gateway (IGW):** Provides internet connectivity to instances in the public subnets.
4. **Amazon NAT Gateway:** Enables instances in the private subnets to initiate outbound traffic to the internet while preventing incoming connections.
5. **Amazon Security Group (SG):** Defines inbound and outbound traffic rules to control network access to instances.
6. **Amazon Application Load Balancer (ALB):** Distributes incoming application traffic across multiple targets, such as Amazon ECS containers.
7. **Amazon ECS Cluster:** Manages containers using the AWS Fargate launch type, abstracting the underlying infrastructure.
8. **Amazon ECS Task Definition:** Specifies the parameters for running containers within an Amazon ECS service.
9. **Amazon Elastic Container Registry (ECR):** A fully managed Docker container registry that stores, manages, and deploys container images.
10. **Amazon IAM Roles and Policies:** Define permissions for different services, allowing them to interact securely.

# Project Workflow

Each project represents a Continuous Deployment to AWS Fargate from GitHub using Terraform:

1. **VPC and Networking:** Create a VPC with specified CIDR blocks, public and private subnets across availability zones, an IGW for public subnet communication, configure NAT Gateway for private subnet outbound communication and set up route tables for public and private subnets.
2. **Security Group:** Create a security group for the ALB. Allow incoming traffic on ports 80 and 5000 for the ALB. Allow all outbound traffic.
3. **Application Load Balancer (ALB):** Create an ALB with specified attributes and subnets and set up ALB target groups and listeners.
4. **Amazon ECS Cluster and Task Definition:** Create an ECS cluster, define an ECS task definition for the application, configure the container definition for the Flask app, an IAM policy for ECS task execution.

# Pricing

## ECS `EC2` launch mode

- Billing is based on the cost of the underlying `EC2 instances`.

- This allows you to optimize price by taking advantage of billing models such as:
- `spot instances` (bid a low price for an instance)
- `reserved instances` (get a flat discount for committing to an instance for a certain period).

- However, it is your responsibility to make sure that your containers are densely packed onto instances to get the best use out of them, otherwise, you will be wasting money.

## ECS `Fargate` launch mode

- Billing is based on how many `CPU` cores, and gigabytes of `memory` your task requires, per second.

- You only ever pay for what your task uses, no more paying for EC2 capacity that goes unused.

<hr>

# Blueprints

## 1. ECS (EC2) Nginx

https://github.com/juanroldan1989/deploy-ecs-blueprint/tree/main/1.ecs-ec2-nginx

![Screenshot 2024-10-01 at 12 14 30](https://github.com/user-attachments/assets/ddf2ccc4-74ab-4ba1-9074-524ebfa0a078)

## 2. ECS (Fargate) Nginx

https://github.com/juanroldan1989/deploy-ecs-blueprint/tree/main/2.ecs-fargate-nginx

![Screenshot 2024-10-03 at 11 55 11](https://github.com/user-attachments/assets/30cbf6f5-2bcb-445c-9364-cf50f9b4a268)

## 3. ECS (FARGATE) Nginx + WSGI + Flask App

https://github.com/juanroldan1989/deploy-ecs-blueprint/tree/main/3.ecs-fargate-nginx-flask

![Screenshot 2024-09-30 at 12 28 13](https://github.com/user-attachments/assets/20bef5c8-8723-40b9-92be-be8427a8ee5e)

- 🟡 Pipeline integrated within `Github Actions` - **work in progress**
- 🟢 Infrastructure provisioned through `Terraform`
- 🟡 `Terraform` State stored in `S3` - **work in progress**
- 🟢 Load Testing performed through `wrk` tool on endpoints

## 4. ECS (FARGATE) Nginx + WSGI + Flask App + DB

https://github.com/juanroldan1989/deploy-ecs-blueprint/tree/main/4.ecs-fargate-nginx-flask-db

![Screenshot 2024-09-30 at 12 28 13](https://github.com/user-attachments/assets/20bef5c8-8723-40b9-92be-be8427a8ee5e)

- 🟡 Pipeline integrated within `Github Actions` - **work in progress**
- 🟢 Infrastructure provisioned through `Terraform`
- 🟢 `MariaDB` database instance added within ECS Fargate Task.
- 🟡 `Terraform` State stored in `S3` - **work in progress**
- 🟢 Load Testing performed through `wrk` tool on endpoints

# Further improvements

## Pipeline

1. Changes are pushed into `main` or `develop` branch.
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
4. New Docker image/s is/are `tagged` and `pushed`.
5. Docker images are scanned:

- Trivy
  Trivy checks for known vulnerabilities in the container image, scanning OS packages and application libraries. The workflow fails if HIGH or CRITICAL vulnerabilities are detected.

- Dockle
  Dockle checks if the Dockerfile follows best practices. It verifies that the container is not running as root, ensures there are no unnecessary files or directories, and more.

6. Infra Costs analisis is provided within `Pull Request`

- https://github.com/kunduso/add-aws-ecr-ecs-fargate/blob/main/.github/workflows/terraform.yml#L70
- https://github.com/infracost/actions/blob/master/README.md

7. `terraform apply` command is triggered using new `IMAGE_TAG` - https://skundunotes.com/2024/05/06/continuous-deployment-of-amazon-ecs-service-using-terraform-and-github-actions/

## Terraform `backend`

https://github.com/kunduso/add-aws-ecr-ecs-fargate/blob/main/deploy/backend.tf

```ruby
terraform {
  backend "s3" {
    bucket  = "ecs-app-XXX"
    encrypt = true
    key     = "terraform-state/terraform.tfstate"
    region  = "us-east-1"
  }
}
```

## Chaos Engineering

- For this section I'm interested in implementing a module to "trigger chaos on command".

- This way it'd be possible to test how each application reacts and recovers from failure scenarios.

# References

- https://spacelift.io/blog/terraform-ecs
- https://github.com/docker/awesome-compose
- https://medium.com/aws-arena/aws-fargate-chaos-monkey-78faa8923af6

# Contribute

Got **something interesting** you'd like to **add or change**? Please feel free to [Open a Pull Request](https://github.com/juanroldan1989/deploy-ecs-blueprint/pulls)

If you want to say **thank you** and/or support the active development of `ECS Deployment Blueprint`:

1. Add a [GitHub Star](https://github.com/juanroldan1989/deploy-ecs-blueprint/stargazers) to the project.
2. Tweet about the project [on your Twitter](https://twitter.com/intent/tweet?text=Hey%20I've%20just%20discovered%20this%20cool%20app%20on%20Github%20by%20@JhonnyDaNiro%20-%20Deploy%20ECS%20Blueprint&url=https://github.com/juanroldan1989/deploy-ecs-blueprint/&via=Github).
3. Write a review or tutorial on [Medium](https://medium.com), [Dev.to](https://dev.to) or personal blog.
