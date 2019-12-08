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
Copy-Item -ErrorAction Stop "${VASMDIR}/vasmm68k_mot_win32.exe" "${BUILD_RESULTS_DIR}/temp/vasmm68k_mot.exe"
Copy-Item -ErrorAction Stop "${VASMDIR}/vasmm68k_std_win32.exe" "${BUILD_RESULTS_DIR}/temp/vasmm68k_std.exe"
Copy-Item -ErrorAction Stop "${VASMDIR}/vobjdump_win32.exe" "${BUILD_RESULTS_DIR}/temp/vobjdump.exe"
Copy-Item -ErrorAction Stop "${VASMDIR}/vasm.pdf" "${BUILD_RESULTS_DIR}/temp/vasm.pdf"
Copy-Item -ErrorAction Stop "LICENSE.md" "${BUILD_RESULTS_DIR}/temp/LICENSE.md"
Compress-Archive -ErrorAction Stop -Path "${BUILD_RESULTS_DIR}/temp/vasmm68k_mot.exe", "${BUILD_RESULTS_DIR}/temp/vasmm68k_std.exe", "${BUILD_RESULTS_DIR}/temp/vobjdump.exe", "${BUILD_RESULTS_DIR}/temp/vasm.pdf", "${BUILD_RESULTS_DIR}/temp/LICENSE.md" -DestinationPath "${BUILD_RESULTS_DIR}/vasmm68k-${VASM_VERSION}-windows-binaries.zip"
Remove-Item -ErrorAction Stop -Force -Recurse "${BUILD_RESULTS_DIR}/temp"
