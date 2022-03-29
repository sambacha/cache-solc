# syntax = docker/dockerfile-upstream:master-experimental
FROM alpine:3.14 AS builder

WORKDIR /usr/src/solc/
RUN mkdir -p .compiler_cache
COPY --chmod=0744 fetch /fetch

ENV SOLC_COMPILER_CACHE=/.compiler_cache

FROM alpine:3.14

#RUN useradd -r -u 1001 -g root solc_user
RUN useradd -ms /bin/bash solc_user

RUN ln -sf /dev/stdout /var/log/app.log
RUN chmod -R g+rwX /var/log

COPY --from=build /.compiler_cache /.compiler_cache
RUN chmod a+rx /usr/local/bin/*

USER solc_user
WORKDIR /opt/solc

# RUN apk add --no-cache bash jq curl ca-certificates 
RUN apk add --no-cache jq curl ca-certificates 

ENV PATH=/opt/solc/.solc-select:${PATH}
ENV SOLC_COMPILER_CACHE=/opt/solc/.compiler_cache

COPY --from=build /.compiler_cache /.compiler_cache
CMD ["--help"]
