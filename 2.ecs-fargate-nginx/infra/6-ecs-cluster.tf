resource "aws_ecs_cluster" "ecs_cluster" {
  name = "my-ecs-cluster"
}

# try this module afterwards
# module "ecs" {
#  source  = "terraform-aws-modules/ecs/aws"
#  version = "~> 4.1.3"

#  cluster_name = local.example

#  # * Allocate 20% capacity to FARGATE and then split
#  # * the remaining 80% capacity 50/50 between FARGATE
#  # * and FARGATE_SPOT.
#  fargate_capacity_providers = {
#   FARGATE = {
#    default_capacity_provider_strategy = {
#     base   = 20
#     weight = 50
#    }
#   }
#   FARGATE_SPOT = {
#    default_capacity_provider_strategy = {
#     weight = 50
#    }
#   }
#  }
# }
