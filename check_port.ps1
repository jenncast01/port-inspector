<#
.SYNOPSIS
    Script: check_port.ps1
    Descripción: Revisa si un puerto TCP está abierto o cerrado en Windows.
.PARAMETER Port
    Puerto TCP a verificar (entre 1 y 65535).
.PARAMETER HostName
    Nombre del equipo o dirección IP a verificar (por defecto: 127.0.0.1).
.EXAMPLE
    .\check_port.ps1 -Port 80
    .\check_port.ps1 443 google.com
#>

param(
    [Parameter(Mandatory = $true, Position = 0, HelpMessage = "Número de puerto a revisar")]
    [ValidateRange(1, 65535)]
    [int]$Port,

    [Parameter(Mandatory = $false, Position = 1)]
    [string]$HostName = "127.0.0.1"
)

# Configurar codificación UTF-8 para evitar caracteres extraños en la consola
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "Verificando puerto $Port en $HostName..." -ForegroundColor Cyan

try {
    $tcpClient = New-Object System.Net.Sockets.TcpClient
    $asyncResult = $tcpClient.BeginConnect($HostName, $Port, $null, $null)
    
    # Timeout de 2 segundos (2000 ms)
    $success = $asyncResult.AsyncWaitHandle.WaitOne(2000, $false)

    if ($success -and $tcpClient.Connected) {
        $tcpClient.EndConnect($asyncResult)
        $tcpClient.Close()
        Write-Host "[ABIERTO] El puerto $Port en $HostName esta ABIERTO." -ForegroundColor Green
        exit 0
    } else {
        $tcpClient.Close()
        Write-Host "[CERRADO] El puerto $Port en $HostName esta CERRADO o no responde." -ForegroundColor Red
        exit 2
    }
} catch {
    Write-Host "[CERRADO] El puerto $Port en $HostName esta CERRADO o no responde." -ForegroundColor Red
    exit 2
}
