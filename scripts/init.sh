#!/usr/bin/dumb-init /bin/sh
echo "init from baseimage"

if [ -f "/srv/init.sh" ]; then
    echo "execute /srv/init.sh"
    chmod +x /srv/init.sh
    su-exec app /srv/init.sh
    if [ "$?" -ne "0" ]; then
        echo "/srv/init.sh failed"
        exit 1
    fi
fi

echo "execute $@"
$@