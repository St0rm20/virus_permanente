# Obtener la ruta del directorio donde se ejecuta este script
$rutaScript = Split-Path -Parent $MyInvocation.MyCommand.Definition

Write-Host @"
--------------------------------------------------------------------------------------------------

   _____                         ____   ____.__                                                
  /     \ _____  ___.__._____    \   \ /   /|__|______ __ __  ______      ____ ___  ___ ____  
 /  \ /  \\__  \<   |  |\__  \    \   Y   / |  \_  __ \  |  \/  ___/    _/ __ \\  \/  // __ \ 
/    Y    \/ __ \\___  | / __ \_   \     /  |  ||  | \/  |  /\___ \     \  ___/ >    <\  ___/ 
\____|__  (____  / ____|(____  /    \___/   |__||__|  |____//____  >  /\ \___  >__/\_ \\___  >
        \/     \/\/          \/                                  \/   \/     \/      \/    \/ 

--------------------------------------------------------------------------------------------------
"@

Write-Host "Iniciando MayaVirus.exe..."
Start-Sleep -Milliseconds 1500
Write-Host "Obteniendo datos..."
Start-Sleep -Seconds 2
Write-Host "MayaVirus instalado correctamente, perdio pc mi papa."
Start-Sleep -Seconds 3

# Definir rutas de los archivos en la misma carpeta del script
$iconoCalvo = Join-Path $rutaScript "calvo.ico"
$fondoCalvo = Join-Path $rutaScript "calvo.jpg"
$rutaCursor = Join-Path $rutaScript "calvo.cur"
$rutaEscritorio = [System.Environment]::GetFolderPath("Desktop")

# Verificar que los archivos existan
if (-not (Test-Path $iconoCalvo)) {
    Write-Host "No se encontró el archivo de ícono: $iconoCalvo"
    exit
}
if (-not (Test-Path $fondoCalvo)) {
    Write-Host "No se encontró el archivo de fondo: $fondoCalvo"
    exit
}
if (-not (Test-Path $rutaCursor)) {
    Write-Host "No se encontró el archivo de cursor: $rutaCursor"
    exit
}

# Cambiar iconos de accesos directos
$accesosDirectos = Get-ChildItem -Path $rutaEscritorio -Filter "*.lnk"
foreach ($atajo in $accesosDirectos) {
    $shell = New-Object -ComObject WScript.Shell
    $lnk = $shell.CreateShortcut($atajo.FullName)
    $lnk.IconLocation = "$iconoCalvo,0"
    $lnk.Save()
}

# Cambiar íconos de carpetas
try {
    $regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons"
    if (-not (Test-Path $regPath)) {
        New-Item -Path $regPath -Force | Out-Null
    }
    Set-ItemProperty -Path $regPath -Name "3" -Value $iconoCalvo
    Write-Host "Datos encriptados correctamente."
}
catch {
    Write-Host "Error al cambiar el ícono de carpetas: $_"
}

# Cambiar ícono de la papelera
try {
    $regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{645FF040-5081-101B-9F08-00AA002F954E}\DefaultIcon"
    if (-not (Test-Path $regPath)) {
        New-Item -Path $regPath -Force | Out-Null
    }
    Set-ItemProperty -Path $regPath -Name "(Default)" -Value $iconoCalvo
    Write-Host "MayaVirus se ha instalado a nivel de kernel correctamente."
}
catch {
    Write-Host "Error al cambiar el ícono de la papelera: $_"
}

# Cambiar fondo de pantalla
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class Wallpaper {
    [DllImport("user32.dll", CharSet = CharSet.Auto)]
    public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@
[Wallpaper]::SystemParametersInfo(20, 0, $fondoCalvo, 3)

# Cambiar cursor del sistema
try {
    Set-ItemProperty -Path "HKCU:\Control Panel\Cursors\" -Name "Arrow" -Value $rutaCursor
    Set-ItemProperty -Path "HKCU:\Control Panel\Cursors\" -Name "IBeam" -Value $rutaCursor
    Set-ItemProperty -Path "HKCU:\Control Panel\Cursors\" -Name "Wait" -Value $rutaCursor
    Set-ItemProperty -Path "HKCU:\Control Panel\Cursors\" -Name "Hand" -Value $rutaCursor
    Set-ItemProperty -Path "HKCU:\Control Panel\Cursors\" -Name "AppStarting" -Value $rutaCursor

    $signature = @"
    [DllImport("user32.dll", SetLastError = true)]
    public static extern bool SystemParametersInfo(int uiAction, int uiParam, ref string pvParam, int fWinIni);
"@
    $systemParametersInfo = Add-Type -MemberDefinition $signature -Name "Win32SystemParametersInfo" -Namespace Win32Functions -PassThru
    $systemParametersInfo::SystemParametersInfo(0x0057, 0, [ref]$null, 3) | Out-Null

    Write-Host "Cursor cambiado exitosamente."
}
catch {
    Write-Host "Error al cambiar el cursor: $_"
}

Start-Sleep -Seconds 6
