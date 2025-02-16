## AWS ECS Fargate

### Simple Setup

https://github.com/juanroldan1989/deploy-ecs-blueprint/tree/main/2.ecs-fargate-nginx

1. ✅ Create AWS VPC
2. ✅ Set up AWS Load Balancer
3. ✅ Create ECS Cluster
4. Build and push Docker image to ECR
5. ✅ Register Task Definition
6. ✅ Launch ECS Service with one ECS Task

### Basic Setup

1. Complete Simple Setup
2. Configure notifications before, during, and after deployment via Slack
3. Implement recurrent health checks to validate ECS Service is operational

### Advanced Setup

1. Complete Basic Setup
2. Enable auto-scaling based on metrics such as number of requests, CPU, and memory usage
3. Configure minimum and maximum number of ECS Tasks per ECS Service (Min: 1, Max: 5)

### Premium Setup

1. Complete Advanced Setup
2. Connect ECS Task with RDS Database
3. Schedule recurring snapshots
4. Develop a disaster recovery plan for the database
5. Simulate disaster scenarios and trigger the recovery process

### Full Setup

1. Complete Premium Setup
2. Set up a metrics dashboard using Grafana

### SQS Integration

1. Complete the Full Setup.
2. ✅ Provision an Amazon SQS Queue.
3. ✅ Develop a script to send messages to the SQS Queue.
4. ✅ Create an additional ECS Service to consume messages from the SQS Queue using long polling.
