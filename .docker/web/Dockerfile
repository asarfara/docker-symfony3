FROM nginx:alpine

ADD .docker/web/prod/default.conf /etc/nginx/conf.d/
COPY symfony /opt/projects/docker-test

EXPOSE 80
