# ECS (FARGATE) Nginx + WSGI + Flask App

https://github.com/docker/awesome-compose/tree/master/nginx-wsgi-flask

1. Build `nginx` image and push to Docker Hub.

```ruby
$ cd nginx

$ docker build -t juanroldan1989/nginx .
$ docker push juanroldan1989/nginx:latest
```

2. Build `flask` image and push to Docker Hub.

```ruby
$ cd flask

$ docker build -t juanroldan1989/flask-app .
$ docker push juanroldan1989/flask-app:latest
```
