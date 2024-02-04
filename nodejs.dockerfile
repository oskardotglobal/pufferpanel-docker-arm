ARG ARCH
FROM ghcr.io/oskardotglobal/pufferpanel:${ARCH}

USER root

RUN apk add --no-cache nodejs npm && \
    echo 'Testing node version' && \
    node --version && \
    echo 'Testing npm version' && \
    npm --version

RUN rm -rf /var/cache/apk/*

USER pufferpanel

# Metadata
ARG VCS_REF
ARG BUILD_DATE
LABEL org.label-schema.vendor=oskardotglobal \
      org.label-schema.license=MIT \
      org.label-schema.build-date="$BUILD_DATE" \
      org.label-schema.vcs-ref="$VCS_REF" \
      org.label-schema.vcs-url="https://github.com/oskardotglobal/pufferpanel-docker-arm"
