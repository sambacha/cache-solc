# syntax=docker/dockerfile:1.4
FROM alpine:3.14 AS builder


RUN apk add --no-cache bash jq curl
WORKDIR /opt/solc/
COPY fetch /fetch

COPY --from=build /.compiler_cache /.compiler_cache
ENV SOLC_COMPILER_CACHE=/.compiler_cache

ENV SOLC_COMPILER_CACHE=/.compiler_cache


RUN ln -sf /dev/stdout /var/log/app.log
RUN useradd -r -u 1001 -g root solc_user
RUN chmod -R g+rwX /var/log

FROM alpine:3.14

RUN useradd -ms /bin/bash solc_user
USER solc_user
WORKDIR /opt/solc

ENV  PATH=/opt/solc/.solc-select:${PATH}
ENV SOLC_COMPILER_CACHE=/opt/solc/.compiler_cache

COPY --from=build /.compiler_cache /.compiler_cache
