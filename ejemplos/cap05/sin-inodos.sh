#!/bin/sh
mkdir -p disco
mount -t tmpfs -o size=10m,nr_inodes=100 tmpfs disco
n=0
while touch "disco/archivo-$n" 2>/dev/null; do
  n=$((n + 1))
done
echo "archivos creados: $n"
touch disco/uno-mas
head -c 5M /dev/zero > disco/archivo-0 &&
  echo "5 MiB en un archivo que ya existía: OK"
df -h disco
df -i disco
