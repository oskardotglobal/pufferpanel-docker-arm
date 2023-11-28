###
# Builder container
###
FROM node:18-alpine AS node

WORKDIR /build
COPY src/client .

RUN yarn install && \
    yarn build

FROM golang:1.21-alpine AS builder

ARG tags=nohost
ARG version=devel
ARG sha=devel
ARG swagversion=1.16.2

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

WORKDIR /build/pufferpanel

COPY src/go.mod src/go.sum ./
RUN go mod download && go mod verify

COPY src .

RUN /bin/sh -c "~/go/bin/swag init --md . -o web/swagger -g web/loader.go"

COPY --from=node /build/frontend/dist /build/pufferpanel/client/frontend/dist

RUN /bin/sh -c "go build -v -buildvcs=false -tags \"$tags\" -ldflags \"-X 'github.com/pufferpanel/pufferpanel/v3.Hash=$sha' -X 'github.com/pufferpanel/pufferpanel/v3.Version=$version'\" -o /pufferpanel/pufferpanel github.com/pufferpanel/pufferpanel/v3/cmd"

RUN /bin/sh -c "mv assets/email /pufferpanel/email && \
    cd client && 
    npm install && \
    npm run build && \
    mv dist /pufferpanel/www/"


###
# Generate final image
###

FROM alpine

EXPOSE 8080 5657

RUN "mkdir -p /etc/pufferpanel && \
    mkdir -p /var/lib/pufferpanel && \
    mkdir -p /var/log/pufferpanel && \
    addgroup --system -g 1000 pufferpanel && \
    adduser -D -H --home /var/lib/pufferpanel --ingroup pufferpanel -u 1000 pufferpanel && \
    chown -R pufferpanel:pufferpanel /etc/pufferpanel /var/lib/pufferpanel /var/log/pufferpanel"

ENV GIN_MODE=release \
    PUFFER_CONFIG=/etc/pufferpanel/config.json

WORKDIR /var/lib/pufferpanel

COPY --from=builder --chown=pufferpanel:pufferpanel /pufferpanel /pufferpanel/bin
COPY --from=builder --chown=pufferpanel:pufferpanel /build/pufferpanel/config.linux.json /etc/pufferpanel/config.json

# Cleanup
RUN /bin/sh -c "rm -rf /var/cache/apk/*"

USER pufferpanel

ENTRYPOINT ["/pufferpanel/bin/pufferpanel"]
CMD ["run"]


