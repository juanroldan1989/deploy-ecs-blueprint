# ECS (EC2) Nginx

![Screenshot 2024-10-01 at 12 14 30](https://github.com/user-attachments/assets/ddf2ccc4-74ab-4ba1-9074-524ebfa0a078)

## Docker Compose

Change dir to project `1.ecs-ec2-nginx`

```ruby
$ docker-compose up
```

Access: `http://localhost:80`

1. Apply changes
2. Update images with `docker-compose build`
3. Run `docker-compose up` again

## Provision Infrastructure

### Docker Images (build/push)

- One option is to build a custom `nginx` image and push your preferred Docker registry:

```ruby
$ cd nginx

$ docker build -t juanroldan1989/custom-nginx .
$ docker push juanroldan1989/custom-nginx:latest
```

- Another option is to use an existing `nginx` image with default configuration:

```
public.ecr.aws/nginx/nginx:1.27.1-alpine3.20-perl
```

- Docker image reference should be adjusted within ECS Task definition:

```ruby
...

container_definitions = jsonencode([
  {
    name      = "nginx"
    image     = "public.ecr.aws/nginx/nginx:1.27.1-alpine3.20-perl"
    cpu       = 256
    memory    = 512
    essential = true

...
```

### Terraform

1. Change dir to project `1.ecs-ec2-nginx/infra`
2. Run commands:

```ruby
$ terraform init
$ terraform apply
```

3. Check `output` section

```ruby
alb_dns_name = "ecs-alb-<account-id>.<region-id>.elb.amazonaws.com"
```

![Screenshot 2024-10-03 at 11 18 34](https://github.com/user-attachments/assets/fb2e8911-9352-4c7f-950e-555d2a25c2d3)

4. Delete infrastructure

To remove all infrastructure managed by Terraform:

```
$ terraform destroy
```

## Load Testing

```ruby
$ brew install wrk
```

### ALB - `/` endpoint

```ruby
$ wrk -t4 -c10000 -d300s http://ecs-alb-2133404748.us-east-1.elb.amazonaws.com/

Running 5m test @ http://ecs-alb-2133404748.us-east-1.elb.amazonaws.com/
  4 threads and 10000 connections

Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency   124.43ms   48.67ms   1.28s    94.49%
    Req/Sec   486.57    206.99   828.00     64.19%
  565013 requests in 5.00m, 459.63MB read
  Socket errors: connect 9754, read 0, write 0, timeout 0
Requests/sec:   1883.18
Transfer/sec:      1.53MB
```

![Screenshot 2024-10-03 at 11 46 48](https://github.com/user-attachments/assets/8c20a43b-5ddc-4b65-88e1-f2713d957df7)
