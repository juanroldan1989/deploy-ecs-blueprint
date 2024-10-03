FROM nginx:alpine

RUN apk add bash

COPY default.conf /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/nginx.conf

WORKDIR /app
