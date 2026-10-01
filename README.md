# Práctica: Verificador de Puertos en Linux (Docker) y Windows (PowerShell)

Esta práctica implementa la verificación de estado de un puerto TCP (abierto o cerrado) en dos entornos:
1. **Linux (Bash en contenedor Docker)**: [check_port.sh](file:///C:/Users/jenni/.gemini/antigravity/scratch/practica_puertos/check_port.sh)
2. **Windows (PowerShell)**: [check_port.ps1](file:///C:/Users/jenni/.gemini/antigravity/scratch/practica_puertos/check_port.ps1)

---

## 1. Verificación de Imágenes de Linux en Docker

Al verificar con `docker images`, se confirmó que cuentas con imágenes oficiales basadas en Linux:
- `ubuntu:24.04` (Ubuntu Linux)
- `python:3.11-slim` (Debian Linux)

---

## 2. Parte 1: Shell Script en Linux con Docker (`check_port.sh`)

### ¿Cómo funciona?
El script toma el puerto como argumento obligatorio y un host opcional (por defecto `127.0.0.1`). Valida que el puerto sea un número entre 1 y 65535 y utiliza `/dev/tcp` nativo de Bash con un timeout de 2 segundos para comprobar si el puerto responde.

### Ejecución en Docker:

Abre PowerShell en esta carpeta (`C:\Users\jenni\.gemini\antigravity\scratch\practica_puertos`) y ejecuta:

#### A. Probar un puerto ABIERTO (ejemplo con `google.com` en puerto 80):
```powershell
docker run --rm -v "${PWD}:/app" -w /app ubuntu:24.04 bash check_port.sh 80 google.com
```
**Salida esperada:**
```text
Verificando puerto 80 en google.com...
[ABIERTO] El puerto 80 en google.com está ABIERTO.
```

#### B. Probar un puerto CERRADO (ejemplo puerto no asignado 54321):
```powershell
docker run --rm -v "${PWD}:/app" -w /app ubuntu:24.04 bash check_port.sh 54321 1.1.1.1
```
**Salida esperada:**
```text
Verificando puerto 54321 en 1.1.1.1...
[CERRADO] El puerto 54321 en 1.1.1.1 está CERRADO o no responde.
```

#### C. Probar en localhost dentro del contenedor:
```powershell
docker run --rm -v "${PWD}:/app" -w /app python:3.11-slim bash -c "python3 -m http.server 8080 & sleep 1; bash check_port.sh 8080"
```

---

## 3. Parte 2: Script Equivalente en Windows con PowerShell (`check_port.ps1`)

### ¿Cómo funciona?
Recibe el parámetro `$Port` (validado entre 1 y 65535) y opcionalmente `$HostName` (por defecto `127.0.0.1`). Utiliza el cliente TCP de .NET (`System.Net.Sockets.TcpClient`) para probar la conexión con timeout inmediato sin bloqueos.

### Ejecución en PowerShell:

#### A. Probar un puerto ABIERTO (puerto 135 local de Windows o 443 en internet):
```powershell
.\check_port.ps1 135
```
o hacia un servidor web:
```powershell
.\check_port.ps1 443 google.com
```
**Salida esperada:**
```text
Verificando puerto 135 en 127.0.0.1...
[ABIERTO] El puerto 135 en 127.0.0.1 está ABIERTO.
```

#### B. Probar un puerto CERRADO:
```powershell
.\check_port.ps1 54321
```
**Salida esperada:**
```text
Verificando puerto 54321 en 127.0.0.1...
[CERRADO] El puerto 54321 en 127.0.0.1 está CERRADO o no responde.
```

---

## 4. Alternativa nativa en PowerShell (`Test-NetConnection`)

En caso de que el profesor prefiera ver el cmdlet nativo de PowerShell `Test-NetConnection`:
```powershell
Test-NetConnection -ComputerName 127.0.0.1 -Port 135
```
El script [check_port.ps1](file:///C:/Users/jenni/.gemini/antigravity/scratch/practica_puertos/check_port.ps1) ya implementa esta lógica de forma optimizada y formateada con colores para entregar.
