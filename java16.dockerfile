ARG ARCH
FROM ghcr.io/oskardotglobal/pufferpanel:${ARCH}

ENV JAVA_HOME=/usr/lib/jvm/java-16-openjdk

USER root

RUN /bin/sh -c echo 'https://dl-cdn.alpinelinux.org/alpine/edge/community' >> /etc/apk/repositories && \
    apk update

RUN apk add --no-cache openjdk16 && \
    ln -sfn /usr/lib/jvm/java-16-openjdk/bin/java /usr/bin/java && \
    ln -sfn /usr/lib/jvm/java-16-openjdk/bin/javac /usr/bin/javac && \
    ln -sfn /usr/lib/jvm/java-16-openjdk/bin/java /usr/bin/java16 && \
    ln -sfn /usr/lib/jvm/java-16-openjdk/bin/javac /usr/bin/javac16 && \
    echo 'Testing Javac 16 path' && \
    javac16 -version && \
    echo 'Testing Java 16 path' && \
    java16 -version && \
    echo 'Testing java path' && \
    java -version && \
    echo 'Testing javac path' && \
    javac -version

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
