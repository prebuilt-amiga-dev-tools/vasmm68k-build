Param (
    [Parameter(Mandatory=$True)][string]$VASMDIR
)

mkdir -ErrorAction Stop -Force "${VASMDIR}/obj_win32"
Push-Location -ErrorAction Stop "${VASMDIR}"
try {
    & nmake /F makefile.Win32 CPU=m68k SYNTAX=mot; if ($LASTEXITCODE -ne 0) { throw }
    & nmake /F makefile.Win32 CPU=m68k SYNTAX=std; if ($LASTEXITCODE -ne 0) { throw }
} finally {
    Pop-Location
}
