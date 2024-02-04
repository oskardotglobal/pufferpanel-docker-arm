ARG ARCH
FROM ghcr.io/oskardotglobal/pufferpanel:${ARCH}

ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk

USER root

RUN echo 'https://dl-cdn.alpinelinux.org/alpine/edge/community' >> /etc/apk/repositories && \
    apk update

RUN apk add --no-cache openjdk8 && \
    ln -sfn /usr/lib/jvm/java-1.8-openjdk/bin/java /usr/bin/java8 && \
    ln -sfn /usr/lib/jvm/java-1.8-openjdk/bin/javac /usr/bin/javac8 && \
    echo 'Testing Javac 8 path' && \
    javac8 -version && \
    echo 'Testing Java 8 path' && \
    java8 -version && \
    echo 'Testing java path'

RUN apk add --no-cache openjdk21 && \
    ln -sfn /usr/lib/jvm/java-21-openjdk/bin/java /usr/bin/java21 && \
    ln -sfn /usr/lib/jvm/java-21-openjdk/bin/javac /usr/bin/javac21 && \
    echo 'Testing Javac 21 path' && \
    javac21 -version && \
    echo 'Testing Java 21 path' && \
    java21 -version

RUN apk add --no-cache openjdk17 && \
    ln -sfn /usr/lib/jvm/java-17-openjdk/bin/java /usr/bin/java && \
    ln -sfn /usr/lib/jvm/java-17-openjdk/bin/javac /usr/bin/javac && \
    ln -sfn /usr/lib/jvm/java-17-openjdk/bin/java /usr/bin/java17 && \
    ln -sfn /usr/lib/jvm/java-17-openjdk/bin/javac /usr/bin/javac17 && \
    echo 'Testing Javac 17 path' && \
    javac17 -version && \
    echo 'Testing Java 17 path' && \
    java17 -version && \
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
