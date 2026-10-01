#!/bin/bash
# ==============================================================================
# Script: check_port.sh
# Descripción: Revisa si un puerto TCP está abierto o cerrado.
# Uso: ./check_port.sh <puerto> [host]
# Ejemplo: ./check_port.sh 80
#          ./check_port.sh 80 google.com
# ==============================================================================

# Validar que se haya ingresado al menos el puerto
if [ -z "$1" ]; then
    echo "================================================="
    echo " ERROR: Debes proporcionar un puerto como argumento."
    echo " Uso: $0 <puerto> [host]"
    echo " Ejemplo: $0 80"
    echo "          $0 443 google.com"
    echo "================================================="
    exit 1
fi

PORT=$1
# Si no se especifica host, por defecto se usa 127.0.0.1 (localhost)
HOST=${2:-"127.0.0.1"}

# Validar que el puerto sea un número válido entre 1 y 65535
if ! [[ "$PORT" =~ ^[0-9]+$ ]] || [ "$PORT" -lt 1 ] || [ "$PORT" -gt 65535 ]; then
    echo "Error: El puerto '$PORT' no es válido. Debe ser un número entre 1 y 65535."
    exit 1
fi

echo "Verificando puerto $PORT en $HOST..."

# Intentar conexión TCP con un timeout de 2 segundos usando /dev/tcp (nativo en Bash)
if timeout 2 bash -c "cat < /dev/null > /dev/tcp/$HOST/$PORT" 2>/dev/null; then
    echo -e "\e[32m[ABIERTO]\e[0m El puerto $PORT en $HOST está ABIERTO."
    exit 0
else
    echo -e "\e[31m[CERRADO]\e[0m El puerto $PORT en $HOST está CERRADO o no responde."
    exit 2
fi
