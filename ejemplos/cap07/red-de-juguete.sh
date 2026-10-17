#!/bin/sh
# Se corre con: unshare --user --map-root-user --net sh red-de-juguete.sh
ip link set lo up
ip link add br0 type bridge
ip addr add 10.88.0.1/24 dev br0
ip link set br0 up
echo 1 > /proc/sys/net/ipv4/ip_forward

caja() {  # $1 nombre, $2 IP/prefijo, $3 salida; deja el PID en $pid
  unshare --net sleep 60 & pid=$!; sleep 0.2
  ip link add "v-$1" type veth peer name eth0 netns "$pid"
  nsenter -t "$pid" -n sh -c "ip link set lo up; ip link set eth0 up
    ip addr add $2 dev eth0; ip route add default via $3"
}
caja c1 10.88.0.2/24 10.88.0.1; C1=$pid
caja c2 10.88.0.3/24 10.88.0.1; C2=$pid
caja afuera 198.51.100.2/24 198.51.100.1; AFUERA=$pid
ip link set v-c1 master br0 up
ip link set v-c2 master br0 up
ip addr add 198.51.100.1/24 dev v-afuera
ip link set v-afuera up

nsenter -t "$C1" -n timeout 60 python3 -m http.server 80 --directory sitio >/dev/null 2>&1 &
WEB=$!
nft -f reglas.nft
sleep 1

prueba() {  # $1 PID, $2 descripción, el resto es el comando
  p=$1; d=$2; shift 2
  if nsenter -t "$p" -n "$@" >/dev/null 2>&1
  then echo "$d: responde"; else echo "$d: no responde"; fi
}
prueba "$C1" "c1 -> c2 (ping)" ping -c1 -W1 10.88.0.3
prueba "$C1" "c1 -> host (ping)" ping -c1 -W1 10.88.0.1
prueba "$AFUERA" "afuera -> host (ping)" ping -c1 -W1 198.51.100.1
prueba "$AFUERA" "afuera -> host:8080 (curl)" curl -s -m 2 http://198.51.100.1:8080/
echo "--- ss -ltn en el host"; ss -ltn
echo "--- ss -ltn en c1"; nsenter -t "$C1" -n ss -ltn
echo "--- nft list ruleset"; nft list ruleset
kill "$WEB" "$C1" "$C2" "$AFUERA"
