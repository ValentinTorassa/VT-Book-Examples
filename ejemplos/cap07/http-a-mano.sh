#!/bin/bash
# Se corre con: unshare --user --map-root-user --net bash http-a-mano.sh
ip link set lo up
python3 -m http.server 8000 --bind 127.0.0.1 \
    --directory sitio >/dev/null 2>&1 &
sleep 1
ss -ltn
exec 3<>/dev/tcp/127.0.0.1/8000
ss -tn
printf 'GET / HTTP/1.1\r\nHost: localhost\r\nConnection: close\r\n\r\n' >&3
cat <&3
kill $!
