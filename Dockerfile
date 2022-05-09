FROM crystallang/crystal:1.4.1

RUN apt update && apt upgrade -y
RUN apt install -y git bash

RUN mkdir -p /root/app

WORKDIR /root/app/

ADD . /root/app/

RUN shards install
RUN crystal build --release ./src/idedit.cr

ENTRYPOINT ./entrypoint.sh
