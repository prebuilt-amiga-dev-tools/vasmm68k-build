Param (
    [Parameter(Mandatory=$True)][string]$VASMDIR, 
    [Parameter(Mandatory=$True)][string]$BUILD_RESULTS_DIR,
    [Parameter(Mandatory=$True)][string]$VASM_VERSION
)

if (Test-Path "${BUILD_RESULTS_DIR}/temp")
{
    Remove-Item -ErrorAction Stop -Force -Recurse "${BUILD_RESULTS_DIR}/temp"
}

mkdir -ErrorAction Stop -Force "${BUILD_RESULTS_DIR}/temp"
Copy-Item -ErrorAction Stop ${VASMDIR}/vasmm68k_mot_win32.exe "${BUILD_RESULTS_DIR}/temp/vasmm68k_mot.exe"
Copy-Item -ErrorAction Stop ${VASMDIR}/vasmm68k_std_win32.exe "${BUILD_RESULTS_DIR}/temp/vasmm68k_std.exe"
Copy-Item -ErrorAction Stop ${VASMDIR}/vobjdump_win32.exe "${BUILD_RESULTS_DIR}/temp/vobjdump.exe"
& candle.exe windows/wix/vasmm68k.wxs -o "${BUILD_RESULTS_DIR}/temp/vasmm68k.wixobj" -arch x64 "-dApplicationVersion=${VASM_VERSION}"; if ($LASTEXITCODE -ne 0) { throw }
& light.exe "${BUILD_RESULTS_DIR}/temp/vasmm68k.wixobj" -o "${BUILD_RESULTS_DIR}/vasmm68k-${VASM_VERSION}-windows-installer.msi" -ext WixUIExtension -loc windows/wix/vasmm68k.wxl; if ($LASTEXITCODE -ne 0) { throw }
Remove-Item -ErrorAction Stop -Force -Recurse "${BUILD_RESULTS_DIR}/temp"
Remove-Item -ErrorAction Stop -Force -Recurse "${BUILD_RESULTS_DIR}/vasmm68k-${VASM_VERSION}-windows-installer.wixpdb"
