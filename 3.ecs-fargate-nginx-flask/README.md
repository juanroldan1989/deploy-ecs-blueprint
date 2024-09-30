# ECS (FARGATE) Nginx + WSGI + Flask App

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

1. Change dir to a project `ecs-fargate-nginx-flask`
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

- `GET /`
- `GET /info`
- `GET /cache-me`
- `GET /health-check`

## ECS Service (update/deployment)

![Screenshot 2024-09-30 at 12 55 06](https://github.com/user-attachments/assets/f258d3fb-09d2-4e01-b64b-9ebc1c42dcdf)

### Before

1 ECS Task Running - Version `20`

### During

1. ECS Task Version `21` is registered and launched

![Screenshot 2024-09-30 at 12 18 43](https://github.com/user-attachments/assets/b25f8f73-a811-486e-8db9-c595e82c70e8)

2. ECS Task Version `20` becomes `inactive`

![Screenshot 2024-09-30 at 14 44 13](https://github.com/user-attachments/assets/b783bd4f-fbcf-41a2-ad37-cad6bb66692d)

![Screenshot 2024-09-30 at 12 19 18](https://github.com/user-attachments/assets/f0dd834a-258c-4558-876e-4827bb92b1a4)

![Screenshot 2024-09-30 at 12 19 39](https://github.com/user-attachments/assets/ce0aa9b1-5a77-4d91-b21f-a3f9180668c4)

### After

![Screenshot 2024-09-30 at 14 46 16](https://github.com/user-attachments/assets/5978340b-a7a7-4a9b-8cd2-b1e0818cc344)

![Screenshot 2024-09-30 at 12 22 01](https://github.com/user-attachments/assets/d2bcc2c4-ca9c-491c-a8c5-6dccccef6c91)

![Screenshot 2024-09-30 at 12 22 08](https://github.com/user-attachments/assets/f1d66f78-7f2b-4226-9811-4bb96f6969be)

## ECS Task replacement (force on deployment)

- Approach 1:

```
$ terraform apply --auto-approve -replace="aws_ecs_task_definition.custom_nginx_flask_task"
```

- Approach 2:
  https://github.com/hashicorp/terraform-provider-aws/issues/13528#issuecomment-797631866

## Flask App

### `hello` endpoint

![Screenshot 2024-09-30 at 12 39 35](https://github.com/user-attachments/assets/0268c725-ab5f-48b0-8698-0aa97bcd2967)

### `info` endpoint

![Screenshot 2024-09-30 at 12 21 18](https://github.com/user-attachments/assets/50df6d33-95d3-4ed4-b63a-83a3a93b9d7f)

## Nginx

### `cache-me` endpoint

![Screenshot 2024-09-30 at 12 13 33](https://github.com/user-attachments/assets/9cf8d577-56e3-477f-9430-1dd2809f81c8)

### Config Details

- `proxy_redirect` command

https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_redirect

### `proxy_redirect off;` on `/` location

![Screenshot 2024-09-30 at 12 26 06](https://github.com/user-attachments/assets/5493eac2-ee91-42b7-b831-4616ef9af0f7)

### `proxy_redirect default;` on `/info` location

![Screenshot 2024-09-30 at 12 25 49](https://github.com/user-attachments/assets/ee766562-b084-456a-a035-e0915fcc8f46)

## Load Testing

```ruby
$ brew install wrk
```

### Flask App - `/` endpoint

```ruby
$ wrk -t4 -c10000 -d300s http://ecs-alb-1596587575.us-east-1.elb.amazonaws.com/

Running 5m test @ http://ecs-alb-1596587575.us-east-1.elb.amazonaws.com/
  4 threads and 10000 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency   460.80ms   57.85ms   1.21s    85.19%
    Req/Sec   134.03     58.38   570.00     71.51%
  159965 requests in 5.00m, 25.48MB read
  Socket errors: connect 9754, read 0, write 0, timeout 0
Requests/sec:    533.07
Transfer/sec:     86.94KB
```

![Screenshot 2024-09-30 at 13 34 56](https://github.com/user-attachments/assets/cab6b6f4-af91-442f-aac4-9502c483d898)

### Flask App - `/info` endpoint

```ruby
wrk -t4 -c10000 -d300s http://ecs-alb-1596587575.us-east-1.elb.amazonaws.com/info

Running 5m test @ http://ecs-alb-1596587575.us-east-1.elb.amazonaws.com/info
  4 threads and 10000 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency   527.77ms   62.54ms 951.82ms   80.04%
    Req/Sec   117.84     69.88   584.00     65.65%
  139654 requests in 5.00m, 38.89MB read
  Socket errors: connect 9754, read 0, write 0, timeout 0
Requests/sec:    465.35
Transfer/sec:    132.70KB
```

![Screenshot 2024-09-30 at 13 33 36](https://github.com/user-attachments/assets/160b9f43-e588-4c50-a015-ff5e8ceaf430)

## References

- WSGI (Web Server Gateway Interface): `gunicorn`

- https://github.com/docker/awesome-compose/tree/master/nginx-wsgi-flask

- AWS Graphical description:
  https://containersonaws.com/pattern/nginx-reverse-proxy-sidecar-ecs-fargate-task

- https://reflectoring.io/upstream-downstream/
