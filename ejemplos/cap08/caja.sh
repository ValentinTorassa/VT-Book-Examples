#!/bin/sh
hostname caja
echo "hostname: $(hostname)"
echo "kernel:   $(uname -r)"
id
ps -o pid,user,args
ip -brief link
