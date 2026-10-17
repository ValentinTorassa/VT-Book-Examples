#!/bin/sh
cg=/sys/fs/cgroup$(cut -d: -f3 /proc/self/cgroup)
echo "memory.max: $(cat "$cg/memory.max")"
echo "pids.max:   $(cat "$cg/pids.max")"
free -h
