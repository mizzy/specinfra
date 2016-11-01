FROM python:2.7-alpine

MAINTAINER "Obytes"

RUN apk add --update \
    supervisor \
    python-dev \
    build-base \
    linux-headers \
    pcre-dev \
    py-pip \
    vim \
    gettext \ 
    bash \
  && rm -rf /var/cache/apk/*

WORKDIR /opt/app

# Clean
RUN apk del -r python-dev
