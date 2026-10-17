#!/bin/sh
cg=/sys/fs/cgroup$(cut -d: -f3 /proc/self/cgroup)
(for i in 1 2 3 4 5 6 7 8; do sleep 1 & done; wait)
echo "la subshell terminó con: $?"
while read -r linea; do echo "$linea"; done < "$cg/pids.events"
