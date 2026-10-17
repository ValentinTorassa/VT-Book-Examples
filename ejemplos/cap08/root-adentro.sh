#!/bin/sh
id -u
grep CapEff /proc/self/status
stat -c '%u:%g %A %n' /etc/shadow
cat /etc/shadow
touch /etc/prueba
