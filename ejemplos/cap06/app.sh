#!/bin/sh
conf=/tmp/vtbook-cap06/app.conf
echo "app: arranco y leo $conf"
[ -r "$conf" ] || { echo "app: no puedo leer $conf" >&2; exit 1; }
echo "app: configuración cargada"
sleep 20
