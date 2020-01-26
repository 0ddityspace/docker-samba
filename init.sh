#!/bin/sh
if [ ! -f /config/config.yaml ]; then
    echo Could not find /config/config.yaml
    exit 0;
fi

echo verification

pykwalify -s /tmp/schema.yaml -d /config/config.yaml
if [ $? -ne 0 ]; then
    echo config.yaml is not correct
    exit 0;
fi

echo execution du fichier

j2 /tmp/adduser.sh.j2 /config/config.yaml | sh

j2 /tmp/smb.conf.j2 /config/config.yaml > /etc/samba/smb.conf

exec "${@}"
