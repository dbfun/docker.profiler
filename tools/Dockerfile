FROM debian:stretch

RUN apt-get update

RUN apt-get install -y percona-toolkit && \
    chsh -s /bin/bash

COPY . /srv

WORKDIR srv
