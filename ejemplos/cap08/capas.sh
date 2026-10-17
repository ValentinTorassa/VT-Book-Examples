#!/bin/sh
mkdir -p imagen cambios trabajo raiz
echo "versión de la imagen" > imagen/config.txt
echo "no me borres" > imagen/clave.txt
unshare --user --map-root-user --mount sh -c '
  mount -t overlay overlay -o lowerdir=imagen,upperdir=cambios,workdir=trabajo raiz
  echo "versión del contenedor" > raiz/config.txt
  rm raiz/clave.txt
  echo "adentro, raiz tiene: $(ls raiz)"
'
ls -l cambios/* imagen/*
cat imagen/config.txt cambios/config.txt
