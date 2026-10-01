# Port Inspector: Verificador de Puertos en Linux y Windows

Herramienta multiplataforma para verificar el estado de un puerto TCP (abierto o cerrado) implementada tanto para entornos **Linux** (Shell Script con Docker) como para **Windows** (PowerShell).

---

## 📁 Estructura del Proyecto

```text
port-inspector/
├── linux/
│   └── check_port.sh       # Script en Bash para Linux / Docker
├── windows/
│   └── check_port.ps1      # Script en PowerShell para Windows
├── .gitignore              # Archivos ignorados por Git
└── README.md               # Documentación y guía de uso
```

---

## 1. Verificación de Imágenes de Linux en Docker

Antes de ejecutar las pruebas en Linux, se verifica que se cuente con una imagen oficial en Docker:

```powershell
docker images
```

Se utilizó la imagen oficial **`ubuntu:24.04`** (también compatible con `python:3.11-slim` o cualquier distribución con Bash).

---

## 2. Linux: Bash Script con Docker (`linux/check_port.sh`)

### ¿Cómo funciona?
Recibe el puerto como argumento obligatorio y un host opcional (por defecto `127.0.0.1`). Valida que el puerto sea numérico (1-65535) y utiliza el mecanismo nativo `/dev/tcp` de Bash con un timeout de 2 segundos.

### Ejecución con Docker:

Desde la raíz del proyecto (`port-inspector`):

#### 🔹 Probar un puerto ABIERTO (ej. puerto 80 hacia `google.com`):
```powershell
docker run --rm -v "${PWD}:/app" -w /app ubuntu:24.04 bash linux/check_port.sh 80 google.com
```
**Salida:**
```text
Verificando puerto 80 en google.com...
[ABIERTO] El puerto 80 en google.com está ABIERTO.
```

#### 🔹 Probar un puerto CERRADO (ej. puerto 54321):
```powershell
docker run --rm -v "${PWD}:/app" -w /app ubuntu:24.04 bash linux/check_port.sh 54321 1.1.1.1
```
**Salida:**
```text
Verificando puerto 54321 en 1.1.1.1...
[CERRADO] El puerto 54321 en 1.1.1.1 está CERRADO o no responde.
```

---

## 3. Windows: PowerShell Script (`windows/check_port.ps1`)

### ¿Cómo funciona?
Recibe el parámetro `-Port` (validado de 1 a 65535) y opcionalmente `-HostName` (por defecto `127.0.0.1`). Utiliza `System.Net.Sockets.TcpClient` de .NET con timeout inmediato para verificar el estado del socket sin demoras.

### Ejecución en PowerShell:

Desde la raíz del proyecto (`port-inspector`):

```powershell
# Habilitar ejecución si es necesario:
Set-ExecutionPolicy -Scope Process Bypass -Force
```

#### 🔹 Probar un puerto ABIERTO (ej. puerto local 135 o 443 en internet):
```powershell
.\windows\check_port.ps1 135
```
*(O hacia un host remoto: `.\windows\check_port.ps1 443 google.com`)*

**Salida:**
```text
Verificando puerto 135 en 127.0.0.1...
[ABIERTO] El puerto 135 en 127.0.0.1 esta ABIERTO.
```

#### 🔹 Probar un puerto CERRADO:
```powershell
.\windows\check_port.ps1 54321
```
**Salida:**
```text
Verificando puerto 54321 en 127.0.0.1...
[CERRADO] El puerto 54321 en 127.0.0.1 esta CERRADO o no responde.
```
