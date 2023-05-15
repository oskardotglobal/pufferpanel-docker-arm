FROM oskardotglobal/pufferpanel:aarch64

ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk

RUN /bin/sh -c "echo 'https://dl-cdn.alpinelinux.org/alpine/edge/community' >> /etc/apk/repositories && \
    apk update"

RUN /bin/sh -c "apk add --no-cache openjdk17 && \
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
    javac -version"

RUN rm -rf /var/cache/apk/*