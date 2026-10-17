#!/bin/sh
python3 -c "b = bytearray(200 * 1024 * 1024)"
echo "python terminó con: $?"
cg=/sys/fs/cgroup$(cut -d: -f3 /proc/self/cgroup)
cat "$cg/memory.max"
grep oom "$cg/memory.events"
