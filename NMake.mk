
# Windows build script

!include Config.mk

VASMDIR=vasm

default: build

.PHONY: clean download build install uninstall

clean:
	powershell -Command "$$ErrorActionPreference = 'Stop'; if (Test-Path $(VASMDIR)) { Remove-Item -Recurse -Force $(VASMDIR) }"
	powershell -Command "$$ErrorActionPreference = 'Stop'; if (Test-Path vasm.tar.gz) { Remove-Item -Recurse -Force vasm.tar.gz }"

download:
 	powershell -Command "$$ErrorActionPreference = 'Stop'; Invoke-WebRequest -Uri $(VASM_URL) -OutFile vasm.tar.gz"
	powershell -Command "$$ErrorActionPreference = 'Stop'; tar -xvf vasm.tar.gz"
	powershell -Command "$$ErrorActionPreference = 'Stop'; Remove-Item vasm.tar.gz"

build:
	powershell -Command "$$ErrorActionPreference = 'Stop'; mkdir -Force $(VASMDIR)/obj_win32"
	powershell -Command "$$ErrorActionPreference = 'Stop'; cd $(VASMDIR); nmake /F makefile.Win32 CPU=m68k SYNTAX=mot; if ($$LASTEXITCODE -ne 0) { throw }; if (Test-Path vasmm68k_mot.exe) { Remove-Item -Force vasmm68k_mot.exe }; Copy-Item vasmm68k_mot_win32.exe vasmm68k_mot.exe"
	powershell -Command "$$ErrorActionPreference = 'Stop'; cd $(VASMDIR); nmake /F makefile.win32 CPU=m68k SYNTAX=std; if ($$LASTEXITCODE -ne 0) { throw }; if (Test-Path vasmm68k_std.exe) { Remove-Item -Force vasmm68k_std.exe }; Copy-Item vasmm68k_std_win32.exe vasmm68k_std.exe"
