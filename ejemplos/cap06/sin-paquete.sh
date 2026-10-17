#!/bin/sh
dir=${1:-/etc/systemd/system/timers.target.wants}
for enlace in "$dir"/*; do
  destino=$(readlink -f "$enlace")
  paquete=$(dpkg -S "$destino" 2>/dev/null | cut -d: -f1)
  echo "${paquete:-SIN PAQUETE}  $(basename "$enlace")"
done
