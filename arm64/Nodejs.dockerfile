FROM ghcr.io/oskardotglobal/pufferpanel:arm64

RUN /bin/sh -c "apk add --no-cache nodejs npm && \
    echo 'Testing node version' && \
    node --version && \
    echo 'Testing npm version' && \
    npm --version"

RUN rm -rf /var/cache/apk/*
