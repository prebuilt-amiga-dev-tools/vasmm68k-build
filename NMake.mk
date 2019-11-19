
# Windows build script

!include Config.mk

VASMDIR=vasm

BUILD_RESULTS_DIR = build_results

default: build

.PHONY: clean download build install uninstall

clean:
	powershell -Command "$$ErrorActionPreference = 'Stop'; if (Test-Path $(VASMDIR)) { Remove-Item -Recurse -Force $(VASMDIR) }"
	powershell -Command "$$ErrorActionPreference = 'Stop'; if (Test-Path vasm.tar.gz) { Remove-Item -Recurse -Force vasm.tar.gz }"
	powershell -Command "$$ErrorActionPreference = 'Stop'; if (Test-Path $(BUILD_RESULTS_DIR)) { Remove-Item -Recurse -Force $(BUILD_RESULTS_DIR) }"

download:
 	powershell -Command "$$ErrorActionPreference = 'Stop'; Invoke-WebRequest -Uri $(VASM_URL) -OutFile vasm.tar.gz"
	powershell -Command "$$ErrorActionPreference = 'Stop'; tar -xvf vasm.tar.gz"
	powershell -Command "$$ErrorActionPreference = 'Stop'; Remove-Item vasm.tar.gz"
	powershell -Command "$$ErrorActionPreference = 'Stop'; Copy-Item Makefile.Win32 vasm"

build:
	powershell -Command "$$ErrorActionPreference = 'Stop'; mkdir -Force $(VASMDIR)/obj_win32"
	powershell -Command "$$ErrorActionPreference = 'Stop'; cd $(VASMDIR); nmake /F makefile.Win32 CPU=m68k SYNTAX=mot; if ($$LASTEXITCODE -ne 0) { throw }"
	powershell -Command "$$ErrorActionPreference = 'Stop'; cd $(VASMDIR); nmake /F makefile.win32 CPU=m68k SYNTAX=std; if ($$LASTEXITCODE -ne 0) { throw }"

package:
	powershell -Command "$$ErrorActionPreference = 'Stop'; mkdir -Force $(BUILD_RESULTS_DIR)"
	powershell -Command "$$ErrorActionPreference = 'Stop'; if (Test-Path $(BUILD_RESULTS_DIR)/vasmm68k_mot.exe) { Remove-Item -Force $(BUILD_RESULTS_DIR)/vasmm68k_mot.exe }; Copy-Item $(VASMDIR)/vasmm68k_mot_win32.exe $(BUILD_RESULTS_DIR)/vasmm68k_mot.exe"
	powershell -Command "$$ErrorActionPreference = 'Stop'; if (Test-Path $(BUILD_RESULTS_DIR)/vasmm68k_std.exe) { Remove-Item -Force $(BUILD_RESULTS_DIR)/vasmm68k_std.exe }; Copy-Item $(VASMDIR)/vasmm68k_std_win32.exe $(BUILD_RESULTS_DIR)/vasmm68k_std.exe"
	powershell -Command "$$ErrorActionPreference = 'Stop'; if (Test-Path $(BUILD_RESULTS_DIR)/vobjdump.exe) { Remove-Item -Force $(BUILD_RESULTS_DIR)/vobjdump.exe }; Copy-Item $(VASMDIR)/vobjdump_win32.exe $(BUILD_RESULTS_DIR)/vobjdump.exe"
	powershell -Command "$$ErrorActionPreference = 'Stop'; Compress-Archive -Path '$(BUILD_RESULTS_DIR)/vasmm68k_mot.exe', '$(BUILD_RESULTS_DIR)/vasmm68k_std.exe', '$(BUILD_RESULTS_DIR)/vobjdump.exe' -DestinationPath $(BUILD_RESULTS_DIR)/vasmm68k-$(VASM_VERSION)-windows-binaries.zip; Remove-Item -Force $(BUILD_RESULTS_DIR)/vasmm68k_mot.exe; Remove-Item -Force $(BUILD_RESULTS_DIR)/vasmm68k_std.exe; Remove-Item -Force $(BUILD_RESULTS_DIR)/vobjdump.exe"
