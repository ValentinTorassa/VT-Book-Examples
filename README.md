# Ejemplos del libro

Código y archivos de ejemplo del libro de Valentín Torassa sobre Linux y ciberseguridad. Cada
carpeta `ejemplos/capNN/` corresponde a un capítulo. El repositorio del manuscrito es privado;
acá solo se publican los archivos que acompañan los listados.

La rama `main` sigue al libro mientras se prepara. Cada edición terminada tendrá una etiqueta de
Git para que una copia impresa apunte a una versión fija. Todavía no hay una edición etiquetada.

## Antes de correrlos

- Leé el capítulo y ejecutá los comandos en una máquina de laboratorio. Algunos ejemplos crean
  namespaces, montajes, interfaces o reglas de firewall y requieren Linux y herramientas del
  sistema. Los del capítulo 7 trabajan en namespaces de red descartables.
- `ejemplos/cap08/compose.yaml` muestra configuraciones deliberadamente peligrosas para
  analizarlas; no es una aplicación para desplegar.
- Las políticas y el registro de AWS del capítulo 9 usan nombres, direcciones y cuentas
  ficticios. `evalua.py` es un modelo local: no llama a AWS ni reemplaza su simulador de IAM.
- `ejemplos/cap10/dos_pedidos.py` usa [VT-Agent-Firewall](https://github.com/ValentinTorassa/VT-Agent-Firewall).
  Para correrlo, copialo a la raíz de ese repositorio, donde están `agent_firewall/`,
  `policies/default.json` y `demo_workspace/`.
- `ejemplos/cap10/agente.py` ejecuta una orden leída de un archivo. Usá solo los archivos de
  demostración incluidos y un entorno descartable.

Los ejemplos se distribuyen bajo [Apache License 2.0](LICENSE).
