
# Add Visual Studio x64 build tools to environment (nmake, cl, link, ...)
# Based on https://github.com/Microsoft/vswhere/wiki/Find-VC#powershell

$vsdevcmdArgs = "-arch=x64 -host_arch=x64"

$vswherePath = ((Get-Item "Env:ProgramFiles(x86)").Value + "\Microsoft Visual Studio\Installer\vswhere.exe")
if (Test-Path $vswherePath) {
  $installationPath = & $vswherePath -prerelease -latest -property installationPath
  if ($installationPath) {
    $vsdevcmdPath = "$installationPath\Common7\Tools\vsdevcmd.bat"
    if (Test-Path $vsdevcmdPath) {
      Write-Output "Adding MSVC build tools to environment..."
      cmd /s /c """$vsdevcmdPath"" $vsdevcmdArgs && set" | where { $_ -match '(\w+)=(.*)' } | foreach {
        $null = New-Item -Force -Path "Env:\$($Matches[1])" -Value $Matches[2]
      }
      get-command nmake.exe
    } else {
      Write-Error -Message "Visual Studio installation at $installationPath does not include vsdevcmd.bat" -Exception ([System.IO.FileNotFoundException]::New()) -ErrorAction Stop
    }
  } else {
    Write-Error -Message "vswhere.exe did not find any Visual Studio installation" -Exception ([System.ApplicationException]::New()) -ErrorAction Stop
  }
} else {
  Write-Error -Message "Could not find vswhere.exe in default location: $vswherePath" -Exception ([System.IO.FileNotFoundException]::New()) -ErrorAction Stop
}
