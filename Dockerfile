###
# Builder container
###
FROM node:16-alpine AS node
FROM golang:1.19-alpine AS builder

COPY --from=node /usr/lib /usr/lib
COPY --from=node /usr/local/share /usr/local/share
COPY --from=node /usr/local/lib /usr/local/lib
COPY --from=node /usr/local/include /usr/local/include
COPY --from=node /usr/local/bin /usr/local/bin

ARG tags=none
ARG version=devel
ARG sha=devel
ARG goproxy
ARG npmproxy
ARG swagversion=1.8.8

ENV CGOENABLED=1

ENV npm_config_registry=$npmproxy
ENV GOPROXY=$goproxy

RUN /bin/sh -c "go version && \
    apk add --update --no-cache gcc musl-dev git curl make gcc g++ && \
    mkdir /pufferpanel && \
    wget https://github.com/swaggo/swag/releases/download/v${swagversion}/swag_${swagversion}_Linux_aarch64.tar.gz && \
    mkdir -p ~/go/bin && \
    tar -zxf swag*.tar.gz -C ~/go/bin && \
    rm -rf swag*.tar.gz"

WORKDIR /build
COPY src /build
RUN /bin/sh -c "go mod download && go mod verify"

RUN /bin/sh -c "~/go/bin/swag init -o web/swagger -g web/loader.go"
RUN /bin/sh -c "go build -v -buildvcs=false -ldflags \"-X 'github.com/pufferpanel/pufferpanel/v2.Hash=$sha' -X 'github.com/pufferpanel/pufferpanel/v2.Version=$version'\" -o /pufferpanel/pufferpanel github.com/pufferpanel/pufferpanel/v2/cmd"

RUN /bin/sh -c "mv assets/email /pufferpanel/email && \
    cd client && \
    npm install && \
    npm run build && \
    mv dist /pufferpanel/www/"


###
# Generate final image
###

FROM alpine
COPY --from=builder /pufferpanel /pufferpanel

EXPOSE 8080 5657

RUN /bin/sh -c "mkdir -p /etc/pufferpanel && \
    mkdir -p /var/lib/pufferpanel"

ENV PUFFER_LOGS=/etc/pufferpanel/logs \
    PUFFER_PANEL_TOKEN_PUBLIC=/etc/pufferpanel/public.pem \
    PUFFER_PANEL_TOKEN_PRIVATE=/etc/pufferpanel/private.pem \
    PUFFER_PANEL_DATABASE_DIALECT=sqlite3 \
    PUFFER_PANEL_DATABASE_URL="file:/etc/pufferpanel/pufferpanel.db?cache=shared" \
    PUFFER_DAEMON_SFTP_KEY=/etc/pufferpanel/sftp.key \
    PUFFER_DAEMON_DATA_CACHE=/var/lib/pufferpanel/cache \
    PUFFER_DAEMON_DATA_SERVERS=/var/lib/pufferpanel/servers \
    PUFFER_DAEMON_DATA_MODULES=/var/lib/pufferpanel/modules \
    PUFFER_DAEMON_DATA_BINARIES=/var/lib/pufferpanel/binaries \
    GIN_MODE=release

# Cleanup
RUN /bin/sh -c "rm -rf /var/cache/apk/*"

WORKDIR /pufferpanel

ENTRYPOINT ["/pufferpanel/pufferpanel"]
CMD ["run"]

# Metadata
ARG VCS_REF
ARG BUILD_DATE
LABEL org.label-schema.vendor=oskardotglobal \
      org.label-schema.license=MIT \
      org.label-schema.build-date="$BUILD_DATE" \
      org.label-schema.vcs-ref="$VCS_REF" \
      org.label-schema.vcs-url="https://github.com/oskardotglobal/pufferpanel-docker-arm"
