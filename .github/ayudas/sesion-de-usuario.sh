#!/bin/bash
# sesion-de-usuario.sh: deja al usuario del runner como en una sesión de escritorio, con su
# propio gestor de systemd (systemd --user), su bus y su journal. Los capítulos 1, 3, 6, 8 y 12
# usan systemd-run --user, systemctl --user y journalctl --user.
set -euo pipefail

usuario=$(id -un)
uid=$(id -u)

# El bus de la sesión lo da dbus-user-session; sin él, systemctl --user no tiene con quién hablar.
if ! dpkg -s dbus-user-session > /dev/null 2>&1; then
  sudo apt-get update -qq
  sudo apt-get install -y -qq dbus-user-session > /dev/null
fi

# journalctl --user lee el journal propio de cada usuario, que journald separa solo si guarda en
# disco (/var/log/journal), como en una instalación común de Debian o de Ubuntu.
if [ ! -d /var/log/journal ]; then
  sudo mkdir -p /var/log/journal
  sudo systemd-tmpfiles --create --prefix /var/log/journal
  sudo systemctl restart systemd-journald
fi

# En el runner nadie inició sesión; con linger, systemd arranca el gestor del usuario igual.
sudo loginctl enable-linger "$usuario"
export XDG_RUNTIME_DIR="/run/user/$uid"
export DBUS_SESSION_BUS_ADDRESS="unix:path=$XDG_RUNTIME_DIR/bus"
for _ in $(seq 60); do
  estado=$(systemctl --user is-system-running 2> /dev/null || true)
  case $estado in running | degraded) break ;; esac
  sleep 0.5
done
echo "systemd --user: ${estado:-sin respuesta}"
systemctl --user --version | head -n 1
echo "controladores delegados: $(cat "/sys/fs/cgroup/user.slice/user-$uid.slice/user@$uid.service/cgroup.controllers" 2> /dev/null || true)"

{
  echo "XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR"
  echo "DBUS_SESSION_BUS_ADDRESS=$DBUS_SESSION_BUS_ADDRESS"
} >> "$GITHUB_ENV"
