FROM golang:1.12-alpine as build

ARG HEY_VERSION=0.1.2

RUN apk add --no-cache git && \
    mkdir -p $GOPATH/src/github.com/rakyll && \
    git clone --branch "v${HEY_VERSION}" https://github.com/rakyll/hey.git $GOPATH/src/github.com/rakyll/hey && \
    go install github.com/rakyll/hey

FROM alpine:3.9

ARG BUILD_DATE
ARG VCS_REF

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="hey" \
      org.label-schema.description="hey load test" \
      org.label-schema.url="https://github.com/kns-it/docker-hey" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/kns-it/docker-hey" \
      org.label-schema.vendor="KNS" \
      org.label-schema.version=$HEY_VERSION \
      org.label-schema.schema-version="1.0" \
      maintainer="sebastian.kurfer@kns-it.de"

COPY --from=build /go/bin/hey /usr/bin/hey

ENTRYPOINT ["/usr/bin/hey"]
