#!/bin/sh
# linterna.sh: qué rutas buscó un comando y no encontró.
# Uso: sh linterna.sh COMANDO [ARGUMENTOS...]
strace -f -e trace=%file -o traza.txt "$@"
grep ENOENT traza.txt | cut -d'"' -f2
