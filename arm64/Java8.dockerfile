FROM ghcr.io/oskardotglobal/pufferpanel:arm64

ENV JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk

RUN /bin/sh -c "echo 'https://dl-cdn.alpinelinux.org/alpine/edge/community' >> /etc/apk/repositories && \
    apk update"

RUN /bin/sh -c "apk add --no-cache openjdk8 && \
    ln -sfn /usr/lib/jvm/java-1.8-openjdk/bin/java /usr/bin/java && \
    ln -sfn /usr/lib/jvm/java-1.8-openjdk/bin/javac /usr/bin/javac && \
    ln -sfn /usr/lib/jvm/java-1.8-openjdk/bin/java /usr/bin/java8 && \
    ln -sfn /usr/lib/jvm/java-1.8-openjdk/bin/javac /usr/bin/javac8 && \
    echo 'Testing Javac 8 path' && \
    javac8 -version && \
    echo 'Testing Java 8 path' && \
    java8 -version && \
    echo 'Testing java path' && \
    java -version && \
    echo 'Testing javac path' && \
    javac -version"

RUN rm -rf /var/cache/apk/*
