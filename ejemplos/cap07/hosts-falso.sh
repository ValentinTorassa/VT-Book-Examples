#!/bin/sh
# Se corre con: unshare --user --map-root-user --mount sh hosts-falso.sh
echo "203.0.113.10 example.com" > hosts
mount --bind hosts /etc/hosts
getent ahostsv4 example.com | head -n 1
dig +short example.com
curl -sv -m 5 http://example.com/ 2>&1 | grep -E 'Trying|timed out'
