
$vswherePath = ((Get-Item "Env:ProgramFiles(x86)").Value + "\Microsoft Visual Studio\Installer\vswhere.exe")
if (Test-Path $vswherePath) {
  $installationPath = & $vswherePath -prerelease -latest -property installationPath
  if ($installationPath) {
    if (Test-Path "$installationPath\Common7\Tools\vsdevcmd.bat") {
      & "${env:COMSPEC}" /s /c "`"$installationPath\Common7\Tools\vsdevcmd.bat`" -arch=x64 -host_arch=x64 -no_logo && set" | foreach-object {
        $name, $value = $_ -split '=', 2
        Set-Content env:\"$name" $value
      }
    } else {
      Write-Error -Message "Visual Studio installation at $installationPath does not include vsdevcmd.bat" -Exception ([System.IO.FileNotFoundException]::New()) -ErrorAction Stop
    }
  } else {
    Write-Error -Message "vswhere.exe did not find any Visual Studio installation" -Exception ([System.ApplicationException]::New()) -ErrorAction Stop
  }
} else {
  Write-Error -Message "Could not find VSWhere.exe in default location: $vswherePath" -Exception ([System.IO.FileNotFoundException]::New()) -ErrorAction Stop
}

