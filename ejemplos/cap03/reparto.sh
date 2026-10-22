#!/bin/sh
taskset -c 0 sh -c 'while :; do :; done' &
a=$!
taskset -c 0 nice -n 10 sh -c 'while :; do :; done' &
b=$!
sleep 10
ps -o pid,ni,time,cmd -p "$a,$b"
kill $a $b
