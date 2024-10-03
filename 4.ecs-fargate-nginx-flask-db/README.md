# ECS (Fargate) Nginx + WSGI + Flask App + Database

![Screenshot 2024-09-30 at 12 28 13](https://github.com/user-attachments/assets/20bef5c8-8723-40b9-92be-be8427a8ee5e)

## Docker Compose

```ruby
$ docker-compose up
```

Access: `http://localhost:8000`

1. Apply changes
2. Update images `docker-compose build`
3. Run `docker-compose up` again

## Provision Infrastructure

### Docker Images (build/push)

1. Build `nginx` image and push to Docker Hub.

```ruby
$ cd nginx

$ docker build -t juanroldan1989/custom-nginx .
$ docker push juanroldan1989/custom-nginx:latest
```

2. Build `flask` image and push to Docker Hub.

```ruby
$ cd flask

$ docker build -t juanroldan1989/flask-app .
$ docker push juanroldan1989/flask-app:latest
```

### Terraform

1. Change dir to a project `ecs-fargate-nginx-flask-db`
2. Run commands:

```ruby
$ terraform init
$ terraform apply
```

3. Check `output` section

```ruby
alb_dns_name = "ecs-alb-<account-id>.<region-id>.elb.amazonaws.com"
```

4. Available endpoints are:

- `GET /` -> Lists all articles

![Screenshot 2024-09-30 at 22 25 46](https://github.com/user-attachments/assets/b879923f-6fac-443d-9e83-fb141d460068)

- `GET /<article-id>` -> Requests an specific article

![Screenshot 2024-09-30 at 22 25 58](https://github.com/user-attachments/assets/52dab504-2f0a-4db1-8884-e383e9771af3)

5. Delete infrastructure

To remove all infrastructure managed by Terraform:

```
$ terraform destroy
```

## ECS Service (update/deployment)

### During

![Screenshot 2024-09-30 at 20 50 16](https://github.com/user-attachments/assets/2e0b1579-4d1f-4fc8-88db-52434b79de83)

### After

![Screenshot 2024-09-30 at 20 51 10](https://github.com/user-attachments/assets/d1e79a33-3683-41f3-9479-41ac4a35cf9c)

![Screenshot 2024-09-30 at 20 51 28](https://github.com/user-attachments/assets/285fee08-54f3-4dc6-b5e6-d467735ba365)

## ECS Task replacement (force on deployment)

- Approach 1:

```
$ terraform apply --auto-approve -replace="aws_ecs_task_definition.custom_nginx_flask_task"
```

- Approach 2:
  https://github.com/hashicorp/terraform-provider-aws/issues/13528#issuecomment-797631866

## Load Testing

```ruby
$ brew install wrk
```

### Flask App - `/` endpoint

```ruby
$ wrk -t4 -c10000 -d300s http://ecs-alb-1190038999.us-east-1.elb.amazonaws.com

Running 5m test @ http://ecs-alb-1190038999.us-east-1.elb.amazonaws.com
  4 threads and 10000 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency   744.19ms  159.61ms   1.60s    81.43%
    Req/Sec    78.60     40.86   515.00     70.56%
  92909 requests in 5.00m, 26.58MB read
  Socket errors: connect 9754, read 4, write 0, timeout 0
Requests/sec:    309.61
Transfer/sec:     90.70KB
```

### Flask App - `/articles/<id>` endpoint

Test with tool to request random article IDs (e.g.:2,4,1,3)

```ruby

```
