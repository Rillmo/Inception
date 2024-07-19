#!/bin/sh

# nginx default 파일 설정
mv /etc/nginx/sites/enabled/default-docker /etc/nginx/sites/enabled/default

exec service nginx start
