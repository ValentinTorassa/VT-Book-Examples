#!/bin/sh
# ficha.sh: lo que Debian sabe de un archivo de tu sistema
archivo=$(readlink -f "$1")
paquete=$(dpkg -S "$archivo" 2>/dev/null | head -1 | cut -d: -f1)
if [ -z "$paquete" ]; then
  echo "$archivo: ningún paquete lo reclama"
  exit 1
fi
dpkg-query -W -f='paquete: ${Package} ${Version}\n' "$paquete"
dpkg-query -W -f='fuente:  ${source:Package}\n' "$paquete"
apt-cache policy "$paquete" | grep -A1 '^ \*\*\*' | tail -1 | sed 's/^ *[0-9]* /origen:  /'
zcat /usr/share/doc/"$paquete"/changelog*.gz 2>/dev/null | head -1 | sed 's/^/último:  /'
for s in preinst postinst prerm postrm; do
  [ -e "/var/lib/dpkg/info/$paquete.$s" ] && echo "script:  $s"
done
exit 0
