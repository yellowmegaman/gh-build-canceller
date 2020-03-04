FROM alpine:3.11.3

LABEL \
  "name"="GitHub Actions stale run canceller" \
  "homepage"="https://github.com/marketplace/actions/gh-actions-stale-run-canceller" \
  "repository"="https://github.com/yellowmegaman/gh-build-canceller"

RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories && \
  apk add --no-cache git hub curl jq bash

ADD *.sh /

ENTRYPOINT ["/entrypoint.sh"]
