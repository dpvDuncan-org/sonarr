#! /bin/sh
chown -R $PUID:$PGID /config

GROUPNAME=$(getent group $PGID | cut -d: -f1)
USERNAME=$(getent passwd $PUID | cut -d: -f1)

if [ ! $GROUPNAME ]
then
        addgroup -g $PGID sonarr
        GROUPNAME=sonarr
fi

if [ ! $USERNAME ]
then
        adduser -G $GROUPNAME -u $PUID -D sonarr
        USERNAME=sonarr
fi

su $USERNAME -c 'mono /opt/sonarr/Sonarr.exe -nobrowser -data=/config'
