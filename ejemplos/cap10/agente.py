#!/usr/bin/env python3
# agente.py: el esqueleto de un agente, sin modelo
import shlex
import subprocess
import sys

texto = open(sys.argv[1], encoding="utf-8").read()
orden = texto.split("CORRÉ:")[1].strip()
print("pedido:", orden, flush=True)
subprocess.run(["sh", "-c", "ps -o pid,ppid,euser,comm -p $PPID,$$"])
r = subprocess.run(shlex.split(orden), capture_output=True, text=True)
print("salida:", r.returncode, (r.stdout or r.stderr).strip())
