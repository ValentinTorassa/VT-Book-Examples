#!/usr/bin/env python3
# dos_pedidos.py: dos lecturas parecidas, dos decisiones
import os

from agent_firewall import ActionRequest, Gateway

gw = Gateway("policies/default.json", "logs/audit.jsonl")
rutas = ["normal/notes.txt", "malicious_repo/config-link"]
for ruta in rutas:
    pedido = ActionRequest(actor="agente", tool="fs.read", params={"path": ruta})
    r = gw.handle(pedido)
    real = os.path.relpath(r["normalized"]["path"])
    print(r["decision"], r["rule_id"], ruta, "->", real)
