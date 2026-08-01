#!/bin/bash

DOMAIN="nacsan.com"

# Lista de servidores DNS: "Nombre|IP|Soporta_DoT|Soporta_DoH"
# Marcamos manualmente los que soportan estándares cifrados por especificación oficial
DNS_SERVERS=(
  "Cloudflare Primary|1.1.1.1|Sí|Sí"
  "Cloudflare Secondary|1.0.0.1|Sí|Sí"
  "Google Primary|8.8.8.8|Sí|Sí"
  "Google Secondary|8.8.4.4|Sí|Sí"
  "Quad9|9.9.9.9|Sí|Sí"
  "AdGuard DNS|94.140.14.14|Sí|Sí"
  "OpenDNS|208.67.222.222|Sí|No"
  "Telefónica / Movistar 1|80.58.61.250|No|No"
  "Telefónica / Movistar 2|80.58.61.254|No|No"
  "Vodafone 1|212.166.210.80|No|No"
  "Vodafone 2|212.166.210.81|No|No"
  "Orange 1|62.36.225.150|No|No"
  "Orange 2|62.37.228.20|No|No"
)

echo "| Proveedor DNS | Dirección IP | Tiempo de Respuesta | DoT (853) | DoH (443) | Status |"
echo "| :--- | :--- | :--- | :--- | :--- | :--- |"

for entry in "${DNS_SERVERS[@]}"; do
  IFS="|" read -r NAME IP DOT DOH <<< "$entry"

  # 1. Consulta estándar (Puerto 53 UDP)
  OUTPUT=$(dig @"$IP" "$DOMAIN" +stats +time=2 +tries=1 2>/dev/null)
  
  QUERY_TIME=$(echo "$OUTPUT" | grep "Query time:" | awk '{print $4 " " $5}')
  STATUS=$(echo "$OUTPUT" | grep "status:" | awk -F'status: ' '{print $2}' | awk '{print $1}' | tr -d ',')

  if [ -z "$QUERY_TIME" ]; then
    QUERY_TIME="Timeout"
    STATUS="ERROR"
  fi

  # 2. Comprobación de puerto DoT (853 TCP) en vivo
  if nc -z -w2 "$IP" 853 2>/dev/null; then
    TEST_DOT="🔒 Sí"
  else
    TEST_DOT="❌ No"
  fi

  echo "| $NAME | \`$IP\` | $QUERY_TIME | $TEST_DOT | $DOH | $STATUS |"
done
