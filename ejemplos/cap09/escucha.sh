#!/bin/sh
ip link set lo up
python3 -m http.server --bind 127.0.0.1 8080 >/dev/null 2>&1 &
a=$!
python3 -m http.server --bind 0.0.0.0 8081 >/dev/null 2>&1 &
b=$!
sleep 1
ss -tln
kill $a $b
