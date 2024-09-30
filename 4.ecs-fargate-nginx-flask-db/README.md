# ECS (FARGATE) Nginx + WSGI + Flask App + Database

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
- `GET /<article-id>` -> Requests an specific article
