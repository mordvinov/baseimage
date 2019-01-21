FROM alpine:3.8

ENV \
    TERM=xterm-color           \
    TIME_ZONE=Europe/Moscow    \
    MYUSER=app                 \
    MYUID=1001                 \
    DOCKER_GID=999         

COPY scripts/app.sh /usr/bin/app.sh
COPY scripts/init.sh /init.sh

RUN \
    chmod +x /usr/bin/app.sh /init.sh && \
    apk add --no-cache --update \
        su-exec=0.2-r0 \
        tzdata=2018f-r0 \
        curl=7.61.1-r1 \
        ca-certificates=20171114-r3 \
        dumb-init=1.2.1-r0 \
    && \
    mkdir -p /home/$MYUSER && \
    adduser -s /bin/sh -D -u $MYUID $MYUSER && chown -R $MYUSER:$MYUSER /home/$MYUSER && \
    delgroup ping && addgroup -g 998 ping && \
    addgroup -g ${DOCKER_GID} docker && addgroup ${MYUSER} docker && \
    mkdir -p /srv && chown -R $MYUSER:$MYUSER /srv && \
    cp /usr/share/zoneinfo/${TIME_ZONE} /etc/localtime && \
    echo "${TIME_ZONE}" > /etc/timezone && echo "current date: $(date)" && \
    rm -rf /var/cache/apk/*

ENTRYPOINT ["/init.sh"]