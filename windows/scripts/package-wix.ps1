Param (
    [Parameter(Mandatory=$True)][string]$VASMDIR, 
    [Parameter(Mandatory=$True)][string]$BUILD_RESULTS_DIR,
    [Parameter(Mandatory=$True)][string]$GITHUB_ORGANIZATION_NAME,
    [Parameter(Mandatory=$True)][string]$VASM_VERSION
)

$VASM_PACKAGE_VERSION = & windows/scripts/get-package-version.ps1 -VASM_VERSION $VASM_VERSION

if (Test-Path "${BUILD_RESULTS_DIR}/temp")
{
    Remove-Item -ErrorAction Stop -Force -Recurse "${BUILD_RESULTS_DIR}/temp"
}

mkdir -ErrorAction Stop -Force "${BUILD_RESULTS_DIR}/temp"
Copy-Item -ErrorAction Stop ${VASMDIR}/vasmm68k_mot_win32.exe "${BUILD_RESULTS_DIR}/temp/vasmm68k_mot.exe"
Copy-Item -ErrorAction Stop ${VASMDIR}/vasmm68k_std_win32.exe "${BUILD_RESULTS_DIR}/temp/vasmm68k_std.exe"
Copy-Item -ErrorAction Stop ${VASMDIR}/vobjdump_win32.exe "${BUILD_RESULTS_DIR}/temp/vobjdump.exe"
Copy-Item -ErrorAction Stop ${VASMDIR}/vasm.pdf "${BUILD_RESULTS_DIR}/temp/vasm.pdf"
& candle.exe windows/wix/vasmm68k.wxs -o "${BUILD_RESULTS_DIR}/temp/vasmm68k.wixobj" -arch x64 "-dApplicationVersion=${VASM_PACKAGE_VERSION}" "-dGithubOrganizationName=${GITHUB_ORGANIZATION_NAME}"; if ($LASTEXITCODE -ne 0) { throw }
& light.exe "${BUILD_RESULTS_DIR}/temp/vasmm68k.wixobj" -o "${BUILD_RESULTS_DIR}/vasmm68k-${VASM_VERSION}-windows-installer.msi" -ext WixUIExtension -loc windows/wix/vasmm68k.wxl -sice:ICE61; if ($LASTEXITCODE -ne 0) { throw }
Remove-Item -ErrorAction Stop -Force -Recurse "${BUILD_RESULTS_DIR}/temp"
Remove-Item -ErrorAction Stop -Force -Recurse "${BUILD_RESULTS_DIR}/vasmm68k-${VASM_VERSION}-windows-installer.wixpdb"
