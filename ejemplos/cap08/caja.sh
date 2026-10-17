#!/bin/sh
hostname caja
echo "hostname: $(hostname)"
echo "kernel:   $(uname -r)"
id
ps -o pid,user,args
readlink /proc/self/ns/user /proc/self/ns/pid /proc/self/ns/uts /proc/self/ns/net
ip -brief link
