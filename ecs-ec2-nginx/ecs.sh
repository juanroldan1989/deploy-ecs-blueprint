#!/bin/bash
# Creates an environment variable in “/etc/ecs/ecs.config” file on each EC2 instance that will be created.
# Without setting this, the ECS service will not be able to deploy and run containers on our EC2 instance.
echo ECS_CLUSTER=my-ecs-cluster >> /etc/ecs/ecs.config
