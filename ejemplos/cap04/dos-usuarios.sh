#!/bin/sh
# Correr con: unshare --user --map-auto --map-root-user --mount sh dos-usuarios.sh
mkdir -p prueba
mount -t tmpfs tmpfs prueba && cd prueba
echo "solo para 2001" > secreto.txt
chown 2001:2001 secreto.txt && chmod 600 secreto.txt
for p in id cat; do cp /usr/bin/$p mi-$p; chown 2001:2001 mi-$p; chmod 4755 mi-$p; done
ls -ln
como2002() { setpriv --reuid=2002 --regid=2002 --clear-groups "$@"; }
como2002 id
como2002 cat secreto.txt
como2002 ./mi-id
como2002 ./mi-cat secreto.txt
