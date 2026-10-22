#!/bin/sh
prueba="systemd-run --user --scope -q -p MemoryMax=50M -p MemorySwapMax=0 \
-p OOMPolicy=continue sh fuga.sh"
evidencia=$($prueba 2>&1)
exec > writeup-fuga.md
echo "# Le pongo un límite de memoria a un proceso y lo mata el kernel"
echo
echo "## Objetivo"
echo "[Qué querías comprobar, en una frase]"
echo
echo "## Entorno"
echo "- $(. /etc/os-release && echo "$PRETTY_NAME"), kernel $(uname -r)"
echo "- $(systemctl --version | head -n 1)"
echo "- fuga.sh, sha256 $(sha256sum fuga.sh | cut -c 1-16)," \
  "corrido el $(date +%F)"
echo
echo "## Prueba"
echo "    $prueba"
echo
echo "## Resultado"
echo "$evidencia" | sed 's/^/    /'
echo
echo "## Explicación"
echo "[Qué capa actuó y qué archivo del kernel lo prueba]"
echo
echo "## Límite"
echo "[Qué no probaste y qué no podés afirmar]"
