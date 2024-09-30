# ECS (FARGATE) Nginx + WSGI + Flask App

![Screenshot 2024-09-30 at 12 28 13](https://github.com/user-attachments/assets/20bef5c8-8723-40b9-92be-be8427a8ee5e)

## References

- WSGI (Web Server Gateway Interface): `gunicorn`

- https://github.com/docker/awesome-compose/tree/master/nginx-wsgi-flask

- AWS Graphical description:
  https://containersonaws.com/pattern/nginx-reverse-proxy-sidecar-ecs-fargate-task

## Docker Images (build/push)

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

## ECS Service deploy

### Before

1 ECS Task Running - Version `20`

### During

1. ECS Task Version `21` is registered and launched

![Screenshot 2024-09-30 at 12 18 43](https://github.com/user-attachments/assets/b25f8f73-a811-486e-8db9-c595e82c70e8)

2. ECS Task Version `20` becomes `inactive`

![Screenshot 2024-09-30 at 12 19 18](https://github.com/user-attachments/assets/f0dd834a-258c-4558-876e-4827bb92b1a4)

![Screenshot 2024-09-30 at 12 19 39](https://github.com/user-attachments/assets/ce0aa9b1-5a77-4d91-b21f-a3f9180668c4)

### After

![Screenshot 2024-09-30 at 12 22 01](https://github.com/user-attachments/assets/d2bcc2c4-ca9c-491c-a8c5-6dccccef6c91)

![Screenshot 2024-09-30 at 12 22 08](https://github.com/user-attachments/assets/f1d66f78-7f2b-4226-9811-4bb96f6969be)

### ECS Task replacement (force on deployment)

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
