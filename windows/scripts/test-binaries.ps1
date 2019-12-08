Param (
    [Parameter(Mandatory=$True)][string]$BUILD_RESULTS_DIR,
    [Parameter(Mandatory=$True)][string]$VASM_VERSION
)

if (Test-Path "${BUILD_RESULTS_DIR}/temp")
{
    Remove-Item -ErrorAction Stop -Force -Recurse "${BUILD_RESULTS_DIR}/temp"
}

mkdir -ErrorAction Stop -Force "${BUILD_RESULTS_DIR}/temp"
Expand-Archive -ErrorAction Stop -Path "${BUILD_RESULTS_DIR}/vasmm68k-${VASM_VERSION}-windows-binaries.zip" -DestinationPath "${BUILD_RESULTS_DIR}/temp"
& "${BUILD_RESULTS_DIR}/temp/vasmm68k_mot.exe" -Fhunk -o "${BUILD_RESULTS_DIR}/temp/test_mot.o" "tests/test_mot.s"; if ($LASTEXITCODE -ne 0) { throw }; if (((Get-FileHash "tests/test_mot.o.expected").hash) -ne ((Get-FileHash "${BUILD_RESULTS_DIR}/temp/test_mot.o").hash)) { throw 'vasmm68k_mot output does not match reference' }
& "${BUILD_RESULTS_DIR}/temp/vasmm68k_std.exe" -Fhunk -o "${BUILD_RESULTS_DIR}/temp/test_std.o" "tests/test_std.s"; if ($LASTEXITCODE -ne 0) { throw }; if (((Get-FileHash "tests/test_std.o.expected").hash) -ne ((Get-FileHash "${BUILD_RESULTS_DIR}/temp/test_std.o").hash)) { throw 'vasmm68k_std output does not match reference' }
& "${BUILD_RESULTS_DIR}/temp/vobjdump.exe" "tests/test_vobjdump.o" > "${BUILD_RESULTS_DIR}/temp/test_vobjdump.dis"; if ($LASTEXITCODE -ne 0) { throw }; if (Compare-Object -ReferenceObject (Get-Content "tests/test_vobjdump.dis.expected") -DifferenceObject (Get-Content "${BUILD_RESULTS_DIR}/temp/test_vobjdump.dis")) { throw 'vobjdump output does not match reference' }
if (!(Test-Path "${BUILD_RESULTS_DIR}/temp/LICENSE.md")) { throw "LICENSE.md is not present within archive" }
Remove-Item -ErrorAction Stop -Force -Recurse ${BUILD_RESULTS_DIR}/temp
