#!/bin/sh
if [ ! -f /config/config.yaml ]; then
    echo Could not find /config/config.yaml
    exit 0;
fi

pykwalify -s /tmp/schema.yaml -d /config/config.yaml
if [ $? -ne 0 ]; then
    echo config.yaml is not correct
    exit 0;
fi

j2 /tmp/setup.sh.j2 /config/config.yaml | sh

j2 /tmp/smb.conf.j2 /config/config.yaml > /etc/samba/smb.conf

exec "${@}"
