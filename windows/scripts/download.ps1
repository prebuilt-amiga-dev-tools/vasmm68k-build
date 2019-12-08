
Param (
    [Parameter(Mandatory=$True)][string]$VASM_URL,
    [Parameter(Mandatory=$True)][string]$VASM_DOC_URL
)

Invoke-WebRequest -ErrorAction Stop -Uri "${VASM_URL}" -OutFile vasm.tar.gz
tar -xvf vasm.tar.gz; if ($LASTEXITCODE -ne 0) { throw }
Remove-Item -ErrorAction Stop vasm.tar.gz
Copy-Item -ErrorAction Stop Windows/Makefile.Win32 vasm

Invoke-WebRequest -ErrorAction Stop -Uri "${VASM_DOC_URL}" -OutFile vasm/vasm.pdf
