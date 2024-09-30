# ECS (FARGATE) Nginx + WSGI + Flask App

- https://github.com/docker/awesome-compose/tree/master/nginx-wsgi-flask

- AWS Graphical description:
  https://containersonaws.com/pattern/nginx-reverse-proxy-sidecar-ecs-fargate-task

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

## Nginx Config Details

- `proxy_redirect` command

https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_redirect

### `proxy_redirect off;` on `/` location

### `proxy_redirect default;` on `/info` location
