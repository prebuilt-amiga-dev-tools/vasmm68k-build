
Param (
    [Parameter(Mandatory=$True)][string]$VASMDIR, 
    [Parameter(Mandatory=$True)][string]$BUILD_RESULTS_DIR
)

if (Test-Path ${VASMDIR})
{
    Remove-Item -ErrorAction Stop -Recurse -Force "${VASMDIR}"
}

if (Test-Path vasm.tar.gz)
{
    Remove-Item -ErrorAction Stop -Recurse -Force vasm.tar.gz
}

if (Test-Path ${BUILD_RESULTS_DIR})
{
    Remove-Item -ErrorAction Stop -Recurse -Force "${BUILD_RESULTS_DIR}"
}

if (Test-Path windows/choco/bin) {
    Remove-Item -ErrorAction Stop -Recurse -Force windows/choco/bin
}
