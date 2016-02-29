# Adapted from https://github.com/oren/alpine-nginx
FROM gliderlabs/alpine:3.3

#ENV NGINX_VERSION 1.8.0-r3
ENV NGINX_VERSION 1.8.1-r0
#ENV NGINX_VERSION 1.9.11-r0

# install nginx without apk index cache, create tmp dir,
# then forward both request and error logs to docker log collector
RUN apk --no-cache add nginx=${NGINX_VERSION} && \
    mkdir -p /tmp/nginx/client-body && \
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY nginx/default.conf /etc/nginx/conf.d/default.conf

# for dev/tester box, just focus on plain HTTP
EXPOSE 80

# daemon off as suggested at https://hub.docker.com/_/nginx/
CMD ["nginx", "-g", "daemon off;"]
