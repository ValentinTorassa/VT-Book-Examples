#!/usr/bin/env python3
# evalua.py: un modelo de juguete de cómo IAM decide. No es el motor de AWS.
import json
import sys
from fnmatch import fnmatchcase
*politicas, accion, recurso = sys.argv[1:]
def lista(valor):
    return valor if isinstance(valor, list) else [valor]
statements = [st for p in politicas for st in lista(json.load(open(p))["Statement"])]
efectos = [st["Effect"] for st in statements
           if any(fnmatchcase(accion, a) for a in lista(st["Action"]))
           and any(fnmatchcase(recurso, r) for r in lista(st["Resource"]))]
if "Deny" in efectos:
    print("Deny explícito")
elif "Allow" in efectos:
    print("Allow")
else:
    print("Deny implícito")
