Param (
    [Parameter(Mandatory=$True)][string]$VASMDIR, 
    [Parameter(Mandatory=$True)][string]$BUILD_RESULTS_DIR,
    [Parameter(Mandatory=$True)][string]$GITHUB_ORGANIZATION_NAME,
    [Parameter(Mandatory=$True)][string]$VASM_VERSION
)

$VASM_PACKAGE_VERSION = & windows/scripts/get-package-version.ps1 -VASM_VERSION $VASM_VERSION

mkdir -ErrorAction Stop -Force "${BUILD_RESULTS_DIR}"

if (Test-Path windows/choco/bin)
{
    Remove-Item -ErrorAction Stop -Force -Recurse windows/choco/bin
}
mkdir -ErrorAction Stop -Force windows/choco/bin
Copy-Item -ErrorAction Stop "${VASMDIR}/vasmm68k_mot_win32.exe" windows/choco/bin/vasmm68k_mot.exe
Copy-Item -ErrorAction Stop "${VASMDIR}/vasmm68k_std_win32.exe" windows/choco/bin/vasmm68k_std.exe
Copy-Item -ErrorAction Stop "${VASMDIR}/vobjdump_win32.exe" windows/choco/bin/vobjdump.exe
& choco.exe pack windows/choco/vasmm68k.nuspec --out "${BUILD_RESULTS_DIR}" --properties "version=${VASM_PACKAGE_VERSION}" "github_organization_name=${GITHUB_ORGANIZATION_NAME}"; if ($LASTEXITCODE -ne 0) { throw }
Remove-Item -ErrorAction Stop -Force -Recurse windows/choco/bin
