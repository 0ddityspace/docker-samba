FROM alpine:latest

RUN apk add --update \
    avahi \
    py-pip \
    samba-client \
    samba-common-tools \
    samba-server \
    supervisor \
    && pip install j2cli[yaml] \
    && pip install pykwalify \
    && sed -i 's/#enable-dbus=yes/enable-dbus=no/g' /etc/avahi/avahi-daemon.conf \
    && rm -rf /var/cache/apk/* \
    && rm /etc/avahi/services/*

VOLUME /share

ADD init.sh /
ADD setup.sh.j2 /tmp
ADD schema.yaml /tmp
ADD smb.conf.j2 /tmp/smb.conf.j2
ADD avahia.service /etc/avahi/services/timemachine.service
ADD supervisord.conf /etc/supervisord.conf

ENTRYPOINT ["/init.sh"]

CMD ["supervisord", "--nodaemon", "--configuration", "/etc/supervisord.conf"]