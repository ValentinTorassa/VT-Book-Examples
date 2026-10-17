#!/bin/sh
# linterna.sh: qué archivos le pide un comando al kernel.
# Uso: sh linterna.sh COMANDO [ARGUMENTOS...]
strace -f -qq -e trace=%file -e signal=none -o traza.txt "$@" >/dev/null
echo "Pedidos sobre archivos: $(grep -vc 'resumed>' traza.txt)"
echo "Rutas que no existían, en orden:"
grep 'ENOENT' traza.txt | cut -d'"' -f2 | awk '!visto[$0]++'
