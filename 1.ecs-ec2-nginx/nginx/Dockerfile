FROM nginx:alpine

# Add bash for boot cmd
RUN apk add bash

# Add nginx config files to container
COPY default.conf /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/nginx.conf

WORKDIR /app

# not using `USER nginx` nor `chwon ...` commands to avoid issues when running ECS Fargate Task:
# - bind() to 0.0.0.0:80 failed (13: Permission denied)
# - /app/start.sh: Permission denied

# to allow nginx to run with standard commands
# CMD ["nginx", "-g", "'daemon off;'"]