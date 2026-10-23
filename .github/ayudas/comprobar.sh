# shellcheck shell=bash
# comprobar.sh: funciones para comparar una corrida con lo que imprime el libro.
#
# Se carga en cada paso de correr-ejemplos.yml con
#   . "$GITHUB_WORKSPACE/.github/ayudas/comprobar.sh"
#
#   donde "Cap. 1, Listado 1-2"     qué parte del libro se comprueba
#   corre NOMBRE SEGUNDOS cmd...    corre cmd con un límite de tiempo y guarda la salida
#                                   (stdout y stderr juntos) y el código en $rc
#   dice / dice_re / linea          la salida tiene que contener ese texto, esa expresión
#                                   regular o esa línea exacta
#   no_dice / no_dice_re            la salida no tiene que contenerlo
#   en_orden a b c                  los textos aparecen en ese orden
#   codigo N                        el código de salida tiene que ser N
#   nota / aviso                    dejan un dato en el resumen; aviso marca una diferencia
#                                   con el libro que depende del entorno (Ubuntu, la red)
#   fin                             termina el paso con 1 si alguna comprobación falló
#
# Las comprobaciones que terminan en _o_avisa no cortan la corrida: dependen de la red o
# de versiones que cambian con el tiempo, y quedan como aviso.

: "${RUNNER_TEMP:=/tmp}"
_fallas=0
_contexto=""
_log=""
rc=0

_celda() { printf '%s' "$*" | sed -e 's/|/\\|/g' -e 's/\r//g'; }

donde() {
  _contexto="$*"
  printf '\n== %s ==\n' "$*"
  if [ -n "${GITHUB_STEP_SUMMARY:-}" ]; then
    printf '\n#### %s\n\n| | Comprobación |\n|---|---|\n' "$*" >> "$GITHUB_STEP_SUMMARY"
  fi
}

corre() {
  local nombre=$1 segundos=$2
  shift 2
  _log="$RUNNER_TEMP/$nombre.log"
  set +e
  timeout --kill-after=5 "$segundos" "$@" > "$_log" 2>&1
  rc=$?
  set -e
  _sin_cr "$_log"
  echo "::group::$nombre (código $rc): $*"
  cat "$_log"
  echo "::endgroup::"
  if [ "$rc" -eq 124 ]; then
    _anota falla "$nombre no terminó en $segundos s"
  fi
}

# usa_log ARCHIVO: compara contra un archivo que dejó el ejemplo, en vez de la salida.
usa_log() { _log=$1; _sin_cr "$_log"; echo "::group::$1"; cat "$1"; echo "::endgroup::"; }

# Las corridas con script(1) simulan una terminal y dejan \r al final de cada renglón.
_sin_cr() { sed -i 's/\r$//' "$1"; }

_anota() {
  local tipo=$1 marca
  shift
  case $tipo in
    ok) marca="✅" ;;
    falla) marca="❌"; _fallas=$((_fallas + 1)) ;;
    aviso) marca="⚠️" ;;
    *) marca="ℹ️" ;;
  esac
  echo "$marca $_contexto: $*"
  if [ -n "${GITHUB_STEP_SUMMARY:-}" ]; then
    printf '| %s | %s |\n' "$marca" "$(_celda "$*")" >> "$GITHUB_STEP_SUMMARY"
  fi
  case $tipo in
    falla) echo "::error title=$_contexto::$(_celda "$*")" ;;
    aviso) echo "::warning title=$_contexto::$(_celda "$*")" ;;
  esac
}

# Con bash -e, una comprobación que no se cumple no puede cortar el paso: por eso cada una
# usa if, y el paso termina recién en fin.
_si() { # _si TIPO_SI_NO TEXTO_OK TEXTO_NO comando...
  local tipo=$1 bien=$2 mal=$3
  shift 3
  if "$@"; then _anota ok "$bien"; else _anota "$tipo" "$mal"; fi
}
_grep() { grep -q "$@" "$_log"; }
_no_grep() { if _grep "$@"; then return 1; fi; }

dice() { _si falla "dice «$1»" "falta «$1»" _grep -F -- "$1"; }
dice_o_avisa() { _si aviso "dice «$1»" "falta «$1»" _grep -F -- "$1"; }
dice_re() { _si falla "coincide /$1/" "ninguna línea coincide con /$1/" _grep -E -- "$1"; }
dice_re_o_avisa() { _si aviso "coincide /$1/" "ninguna línea coincide con /$1/" _grep -E -- "$1"; }
linea() { _si falla "línea «$1»" "falta la línea «$1»" _grep -xF -- "$1"; }
linea_o_avisa() { _si aviso "línea «$1»" "falta la línea «$1»" _grep -xF -- "$1"; }
no_dice() { _si falla "no dice «$1»" "no debería decir «$1»" _no_grep -F -- "$1"; }
no_dice_re() { _si falla "nada coincide con /$1/" "no debería coincidir /$1/" _no_grep -E -- "$1"; }

en_orden() {
  local desde=0 n t
  for t in "$@"; do
    n=$(awk -v d="$desde" -v t="$t" 'NR > d && index($0, t) { print NR; exit }' "$_log")
    if [ -z "$n" ]; then
      _anota falla "falta «$t» después de la línea $desde (orden esperado: $*)"
      return 0
    fi
    desde=$n
  done
  _anota ok "en orden: $*"
}

codigo() {
  if [ "$rc" -eq "$1" ]; then _anota ok "código de salida $1"
  else _anota falla "código de salida $rc; el libro espera $1"; fi
}

nota() { _anota nota "$*"; }
aviso() { _anota aviso "$*"; }
falla() { _anota falla "$*"; }
bien() { _anota ok "$*"; }

fin() {
  if [ "$_fallas" -ne 0 ]; then
    echo "$_fallas comprobaciones no coinciden con el libro"
    exit 1
  fi
}
