FROM alpine:3.11.3

LABEL \
  "name"="GitHub Pull Request Rechecker" \
  "homepage"="https://github.com/marketplace/actions/github-pull-request-rechecker" \
  "repository"="https://github.com/yellowmegaman/prtrigger"

RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories && \
  apk add --no-cache git hub curl jq bash

ADD *.sh /

ENTRYPOINT ["/entrypoint.sh"]
