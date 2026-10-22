#!/bin/sh
set -e
backup=$(realpath "$1")
manifiesto=$(realpath "$2")
destino=$(mktemp -d)
trap 'rm -rf "$destino"' EXIT
tar -xzf "$backup" -C "$destino"
cd "$destino"
sha256sum --quiet -c "$manifiesto"
echo "restore OK: $(wc -l < "$manifiesto") archivos iguales al original"
