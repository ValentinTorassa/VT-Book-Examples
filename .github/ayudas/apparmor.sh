#!/bin/bash
# apparmor.sh bajar|restaurar: la nota del capítulo 4 sobre Ubuntu 24.04. Ubuntu restringe los
# user namespaces que crea un usuario sin privilegios; los ejemplos con unshare sin root necesitan
# bajar esa protección, y el libro lo recomienda solo en una VM descartable, como esta.
set -euo pipefail
clave=kernel.apparmor_restrict_unprivileged_userns
archivo=/proc/sys/kernel/apparmor_restrict_unprivileged_userns

case ${1:-} in
  bajar)
    if [ ! -e "$archivo" ]; then
      echo "Este kernel no tiene $clave; no hay nada que bajar."
      exit 0
    fi
    echo "APPARMOR_ORIGINAL=$(cat "$archivo")" >> "$GITHUB_ENV"
    sudo sysctl -w "$clave=0"
    ;;
  restaurar)
    if [ -e "$archivo" ]; then
      sudo sysctl -w "$clave=${APPARMOR_ORIGINAL:-1}"
    fi
    ;;
  *)
    echo "Uso: $0 bajar|restaurar" >&2
    exit 2
    ;;
esac
