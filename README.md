# Ejemplos del libro

Código y archivos de ejemplo del libro de Valentín Torassa sobre Linux y ciberseguridad. Cada
carpeta `ejemplos/capNN/` corresponde a un capítulo. El repositorio del manuscrito es privado;
acá solo se publican los archivos que acompañan los listados.

Podés leer el [primer capítulo completo, «Toda abstracción filtra»](https://valentorassa.com/libro?ref=muestra-ejemplos),
gratis y sin registro. La muestra tiene 15 páginas, con la explicación y los dibujos que
acompañan a `ejemplos/cap01/fuga.sh`. El libro sigue en preparación.

La rama `main` sigue al libro. Cada edición impresa tiene una etiqueta de Git con los ejemplos tal
como salen en el papel. La primera edición (ISBN 978-631-01-9288-8) es `primera-edicion`:

```bash
git clone --branch primera-edicion https://github.com/ValentinTorassa/VT-Book-Examples.git
```

En cada cambio, [Revisar ejemplos](https://github.com/ValentinTorassa/VT-Book-Examples/actions/workflows/revisar-ejemplos.yml)
comprueba la sintaxis de los scripts y que los JSON se puedan leer, y
[Correr ejemplos](https://github.com/ValentinTorassa/VT-Book-Examples/actions/workflows/correr-ejemplos.yml)
los ejecuta en una VM descartable con Ubuntu 24.04 y compara la salida con la que imprime el libro.
Los listados con systemd y los del capítulo 11 se repiten en un contenedor de Debian 13, el
sistema de las pruebas del libro. El resumen de cada corrida separa lo que coincide de lo que
cambia en Ubuntu. No se ejecuta `ejemplos/cap08/compose.yaml`, que es para analizarlo y usa
imágenes que no existen; se comprueba el `grep` del capítulo 8. Ningún ejemplo necesita una cuenta
de la nube: los del capítulo 9 se evalúan con `evalua.py` y `jq`, como en el libro.

## Antes de correrlos

- Leé el capítulo y ejecutá los comandos en una máquina de laboratorio. Algunos ejemplos crean
  namespaces, montajes, interfaces o reglas de firewall y requieren Linux y herramientas del
  sistema. En Ubuntu 24.04 con AppArmor, los tres scripts del capítulo 7 fallaron al crear un
  namespace de usuario; [la corrida en una VM y su comparación](https://github.com/ValentinTorassa/VT-Book-Examples/actions/runs/39048287569)
  muestran el motivo. Usá una VM descartable para esa práctica.
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
