# Adapted from https://github.com/oren/alpine-nginx
FROM gliderlabs/alpine:3.4

ENV NGINX_VERSION 1.10.1-r1

# install nginx without apk index cache, create tmp dir,
# then forward both request and error logs to docker log collector
RUN apk --no-cache add nginx=${NGINX_VERSION} && \
    mkdir -p /tmp/nginx/client-body && \
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY nginx/default.conf /etc/nginx/conf.d/default.conf

# only listen on plain HTTP
# - in dev/test box, we test in plain HTTP
# - in prod, nginx sits behind SSL-terminating ELB
EXPOSE 80

# daemon off as suggested at https://hub.docker.com/_/nginx/
CMD ["nginx", "-g", "daemon off;"]
