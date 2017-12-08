FROM nginx:alpine

ADD .docker/web/default.conf /etc/nginx/conf.d/
COPY symfony /opt/projects/docker-test

EXPOSE 80
