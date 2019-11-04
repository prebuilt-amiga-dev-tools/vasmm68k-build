
$installationPath = & ((Get-Item "Env:ProgramFiles(x86)").Value + "\Microsoft Visual Studio\Installer\vswhere.exe") -prerelease -latest -property installationPath
if ($installationPath -and (test-path "$installationPath\Common7\Tools\vsdevcmd.bat")) {
  & "${env:COMSPEC}" /s /c "`"$installationPath\Common7\Tools\vsdevcmd.bat`" -arch=x64 -host_arch=x64 -no_logo && set" | foreach-object {
    $name, $value = $_ -split '=', 2
    set-content env:\"$name" $value
  }
}
