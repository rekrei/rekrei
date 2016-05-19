FROM nginx

RUN rm -rf /usr/share/nginx/html
COPY public /usr/share/nginx/html
COPY config/deploy/nginx/nginx.conf /etc/nginx/conf.d/default.conf
