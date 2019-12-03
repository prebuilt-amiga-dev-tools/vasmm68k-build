
# Windows build script

!include Config.mk

VASMDIR=vasm

BUILD_RESULTS_DIR = build_results

default: clean download build package test-packages

package: package-binaries package-wix package-choco

test-packages: test-binaries test-wix test-choco

.PHONY: clean download build package test-package
.PHONY: package-binaries package-wix package-choco
.PHONY: test-binaries test-wix test-choco

clean:
	powershell -Command "gcm get-file*"
	powershell -Command "Get-ChildItem Env:"

	powershell -Command "$$ErrorActionPreference = 'Stop'; if (Test-Path $(VASMDIR)) { Remove-Item -Recurse -Force $(VASMDIR) }"
	powershell -Command "$$ErrorActionPreference = 'Stop'; if (Test-Path vasm.tar.gz) { Remove-Item -Recurse -Force vasm.tar.gz }"
	powershell -Command "$$ErrorActionPreference = 'Stop'; if (Test-Path $(BUILD_RESULTS_DIR)) { Remove-Item -Recurse -Force $(BUILD_RESULTS_DIR) }"
	powershell -Command "$$ErrorActionPreference = 'Stop'; if (Test-Path choco/bin) { Remove-Item -Recurse -Force choco/bin }"

download:
 	powershell -Command "$$ErrorActionPreference = 'Stop'; Invoke-WebRequest -Uri $(VASM_URL) -OutFile vasm.tar.gz"
	powershell -Command "$$ErrorActionPreference = 'Stop'; tar -xvf vasm.tar.gz"
	powershell -Command "$$ErrorActionPreference = 'Stop'; Remove-Item vasm.tar.gz"
	powershell -Command "$$ErrorActionPreference = 'Stop'; Copy-Item Makefile.Win32 vasm"

build:
	powershell -Command "$$ErrorActionPreference = 'Stop'; mkdir -Force $(VASMDIR)/obj_win32"
	powershell -Command "$$ErrorActionPreference = 'Stop'; cd $(VASMDIR); nmake /F makefile.Win32 CPU=m68k SYNTAX=mot; if ($$LASTEXITCODE -ne 0) { throw }"
	powershell -Command "$$ErrorActionPreference = 'Stop'; cd $(VASMDIR); nmake /F makefile.win32 CPU=m68k SYNTAX=std; if ($$LASTEXITCODE -ne 0) { throw }"

package-binaries:
	powershell -Command "$$ErrorActionPreference = 'Stop'; if (Test-Path $(BUILD_RESULTS_DIR)/temp) { Remove-Item -Force -Recurse $(BUILD_RESULTS_DIR)/temp }"
	powershell -Command "$$ErrorActionPreference = 'Stop'; mkdir -Force $(BUILD_RESULTS_DIR)/temp"
	powershell -Command "$$ErrorActionPreference = 'Stop'; Copy-Item $(VASMDIR)/vasmm68k_mot_win32.exe $(BUILD_RESULTS_DIR)/temp/vasmm68k_mot.exe"
	powershell -Command "$$ErrorActionPreference = 'Stop'; Copy-Item $(VASMDIR)/vasmm68k_std_win32.exe $(BUILD_RESULTS_DIR)/temp/vasmm68k_std.exe"
	powershell -Command "$$ErrorActionPreference = 'Stop'; Copy-Item $(VASMDIR)/vobjdump_win32.exe $(BUILD_RESULTS_DIR)/temp/vobjdump.exe"
	powershell -Command "$$ErrorActionPreference = 'Stop'; Compress-Archive -Path '$(BUILD_RESULTS_DIR)/temp/vasmm68k_mot.exe', '$(BUILD_RESULTS_DIR)/temp/vasmm68k_std.exe', '$(BUILD_RESULTS_DIR)/temp/vobjdump.exe' -DestinationPath $(BUILD_RESULTS_DIR)/vasmm68k-$(VASM_VERSION)-windows-binaries.zip"
	powershell -Command "$$ErrorActionPreference = 'Stop'; Remove-Item -Force -Recurse $(BUILD_RESULTS_DIR)/temp"

package-wix:
	powershell -Command "$$ErrorActionPreference = 'Stop'; if (Test-Path $(BUILD_RESULTS_DIR)/temp) { Remove-Item -Force -Recurse $(BUILD_RESULTS_DIR)/temp }"
	powershell -Command "$$ErrorActionPreference = 'Stop'; mkdir -Force $(BUILD_RESULTS_DIR)/temp"
	powershell -Command "$$ErrorActionPreference = 'Stop'; Copy-Item $(VASMDIR)/vasmm68k_mot_win32.exe $(BUILD_RESULTS_DIR)/temp/vasmm68k_mot.exe"
	powershell -Command "$$ErrorActionPreference = 'Stop'; Copy-Item $(VASMDIR)/vasmm68k_std_win32.exe $(BUILD_RESULTS_DIR)/temp/vasmm68k_std.exe"
	powershell -Command "$$ErrorActionPreference = 'Stop'; Copy-Item $(VASMDIR)/vobjdump_win32.exe $(BUILD_RESULTS_DIR)/temp/vobjdump.exe"
	powershell -Command "$$ErrorActionPreference = 'Stop'; & candle.exe wix/vasmm68k.wxs -o '$(BUILD_RESULTS_DIR)/temp/vasmm68k.wixobj' -arch x64 '-dApplicationVersion=$(VASM_VERSION)'"
	powershell -Command "$$ErrorActionPreference = 'Stop'; light.exe $(BUILD_RESULTS_DIR)/temp/vasmm68k.wixobj -o '$(BUILD_RESULTS_DIR)/vasmm68k-$(VASM_VERSION)-windows-installer.msi' -loc wix/vasmm68k.wxl"
	powershell -Command "$$ErrorActionPreference = 'Stop'; Remove-Item -Force -Recurse $(BUILD_RESULTS_DIR)/temp"
	powershell -Command "$$ErrorActionPreference = 'Stop'; Remove-Item -Force -Recurse $(BUILD_RESULTS_DIR)/vasmm68k-$(VASM_VERSION)-windows-installer.wixpdb"

package-choco:
	powershell -Command "$$ErrorActionPreference = 'Stop'; mkdir -Force $(BUILD_RESULTS_DIR)"
	powershell -Command "$$ErrorActionPreference = 'Stop'; if (Test-Path choco/bin) { Remove-Item -Force -Recurse choco/bin }"
	powershell -Command "$$ErrorActionPreference = 'Stop'; mkdir -Force choco/bin"
	powershell -Command "$$ErrorActionPreference = 'Stop'; Copy-Item $(VASMDIR)/vasmm68k_mot_win32.exe choco/bin/vasmm68k_mot.exe"
	powershell -Command "$$ErrorActionPreference = 'Stop'; Copy-Item $(VASMDIR)/vasmm68k_std_win32.exe choco/bin/vasmm68k_std.exe"
	powershell -Command "$$ErrorActionPreference = 'Stop'; Copy-Item $(VASMDIR)/vobjdump_win32.exe choco/bin/vobjdump.exe"
	powershell -Command "$$ErrorActionPreference = 'Stop'; choco.exe pack choco/vasmm68k.nuspec --out $(BUILD_RESULTS_DIR) --properties version=$(VASM_VERSION)"
	powershell -Command "$$ErrorActionPreference = 'Stop'; Remove-Item -Force -Recurse choco/bin"

test-binaries:
	powershell -Command "$$ErrorActionPreference = 'Stop'; if (Test-Path $(BUILD_RESULTS_DIR)/temp) { Remove-Item -Force -Recurse $(BUILD_RESULTS_DIR)/temp }"
	powershell -Command "$$ErrorActionPreference = 'Stop'; mkdir -Force $(BUILD_RESULTS_DIR)/temp"
	powershell -Command "$$ErrorActionPreference = 'Stop'; Expand-Archive -Path '$(BUILD_RESULTS_DIR)/vasmm68k-$(VASM_VERSION)-windows-binaries.zip' -DestinationPath '$(BUILD_RESULTS_DIR)/temp'"
	powershell -Command "$$ErrorActionPreference = 'Stop'; & '$(BUILD_RESULTS_DIR)/temp/vasmm68k_mot.exe' -Fhunk -o '$(BUILD_RESULTS_DIR)/temp/test_mot.o' tests/test_mot.s; if ($$LASTEXITCODE -ne 0) { throw }; if (((Get-FileHash 'tests/test_mot.o.expected').hash) -ne ((Get-FileHash '$(BUILD_RESULTS_DIR)/temp/test_mot.o').hash)) { throw 'vasmm68k_mot output does not match reference' }"
	powershell -Command "$$ErrorActionPreference = 'Stop'; & '$(BUILD_RESULTS_DIR)/temp/vasmm68k_std.exe' -Fhunk -o '$(BUILD_RESULTS_DIR)/temp/test_std.o' tests/test_std.s; if ($$LASTEXITCODE -ne 0) { throw }; if (((Get-FileHash 'tests/test_std.o.expected').hash) -ne ((Get-FileHash '$(BUILD_RESULTS_DIR)/temp/test_std.o').hash)) { throw 'vasmm68k_std output does not match reference' }"
	powershell -Command "$$ErrorActionPreference = 'Stop'; & '$(BUILD_RESULTS_DIR)/temp/vobjdump.exe' 'tests/test_vobjdump.o' > '$(BUILD_RESULTS_DIR)/temp/test_vobjdump.dis'; if ($$LASTEXITCODE -ne 0) { throw }; if (Compare-Object -ReferenceObject (Get-Content 'tests/test_vobjdump.dis.expected') -DifferenceObject (Get-Content '$(BUILD_RESULTS_DIR)/temp/test_vobjdump.dis')) { throw 'vobjdump output does not match reference' }"
	powershell -Command "$$ErrorActionPreference = 'Stop'; Remove-Item -Force -Recurse $(BUILD_RESULTS_DIR)/temp"

test-wix:
	powershell -Command "$$ErrorActionPreference = 'Stop'; if (Test-Path $(BUILD_RESULTS_DIR)/temp) { Remove-Item -Force -Recurse $(BUILD_RESULTS_DIR)/temp }"
	powershell -Command "$$ErrorActionPreference = 'Stop'; mkdir -Force $(BUILD_RESULTS_DIR)/temp"
	powershell -Command "$$ErrorActionPreference = 'Stop'; & '$(BUILD_RESULTS_DIR)/vasmm68k-$(VASM_VERSION)-windows-installer.msi' /quiet; refreshenv"
	powershell -Command "$$ErrorActionPreference = 'Stop'; & vasmm68k_mot.exe -Fhunk -o '$(BUILD_RESULTS_DIR)/temp/test_mot.o' tests/test_mot.s; if ($$LASTEXITCODE -ne 0) { throw }; if (((Get-FileHash 'tests/test_mot.o.expected').hash) -ne ((Get-FileHash '$(BUILD_RESULTS_DIR)/temp/test_mot.o').hash)) { throw 'vasmm68k_mot output does not match reference' }"
	powershell -Command "$$ErrorActionPreference = 'Stop'; & vasmm68k_std.exe -Fhunk -o '$(BUILD_RESULTS_DIR)/temp/test_std.o' tests/test_std.s; if ($$LASTEXITCODE -ne 0) { throw }; if (((Get-FileHash 'tests/test_std.o.expected').hash) -ne ((Get-FileHash '$(BUILD_RESULTS_DIR)/temp/test_std.o').hash)) { throw 'vasmm68k_std output does not match reference' }"
	powershell -Command "$$ErrorActionPreference = 'Stop'; & vobjdump.exe 'tests/test_vobjdump.o' > '$(BUILD_RESULTS_DIR)/temp/test_vobjdump.dis'; if ($$LASTEXITCODE -ne 0) { throw }; if (Compare-Object -ReferenceObject (Get-Content 'tests/test_vobjdump.dis.expected') -DifferenceObject (Get-Content '$(BUILD_RESULTS_DIR)/temp/test_vobjdump.dis')) { throw 'vobjdump output does not match reference' }"
	powershell -Command "$$ErrorActionPreference = 'Stop'; & msiexec /x '$(BUILD_RESULTS_DIR)/vasmm68k-$(VASM_VERSION)-windows-installer.msi' /quiet; refreshenv"
	powershell -Command "$$ErrorActionPreference = 'Stop'; Remove-Item -Force -Recurse $(BUILD_RESULTS_DIR)/temp"

test-choco:
	powershell -Command "$$ErrorActionPreference = 'Stop'; if (Test-Path $(BUILD_RESULTS_DIR)/temp) { Remove-Item -Force -Recurse $(BUILD_RESULTS_DIR)/temp }"
	powershell -Command "$$ErrorActionPreference = 'Stop'; mkdir -Force $(BUILD_RESULTS_DIR)/temp"
	powershell -Command "$$ErrorActionPreference = 'Stop'; & choco install -y '$(BUILD_RESULTS_DIR)/vasmm68k.$(VASM_VERSION).nupkg'; if ($$LASTEXITCODE -ne 0) { throw }"
	powershell -Command "$$ErrorActionPreference = 'Stop'; & vasmm68k_mot.exe -Fhunk -o '$(BUILD_RESULTS_DIR)/temp/test_mot.o' tests/test_mot.s; if ($$LASTEXITCODE -ne 0) { throw }; if (((Get-FileHash 'tests/test_mot.o.expected').hash) -ne ((Get-FileHash '$(BUILD_RESULTS_DIR)/temp/test_mot.o').hash)) { throw 'vasmm68k_mot output does not match reference' }"
	powershell -Command "$$ErrorActionPreference = 'Stop'; & vasmm68k_std.exe -Fhunk -o '$(BUILD_RESULTS_DIR)/temp/test_std.o' tests/test_std.s; if ($$LASTEXITCODE -ne 0) { throw }; if (((Get-FileHash 'tests/test_std.o.expected').hash) -ne ((Get-FileHash '$(BUILD_RESULTS_DIR)/temp/test_std.o').hash)) { throw 'vasmm68k_std output does not match reference' }"
	powershell -Command "$$ErrorActionPreference = 'Stop'; & vobjdump.exe 'tests/test_vobjdump.o' > '$(BUILD_RESULTS_DIR)/temp/test_vobjdump.dis'; if ($$LASTEXITCODE -ne 0) { throw }; if (Compare-Object -ReferenceObject (Get-Content 'tests/test_vobjdump.dis.expected') -DifferenceObject (Get-Content '$(BUILD_RESULTS_DIR)/temp/test_vobjdump.dis')) { throw 'vobjdump output does not match reference' }"
	powershell -Command "$$ErrorActionPreference = 'Stop'; & choco uninstall vasmm68k; if ($$LASTEXITCODE -ne 0) { throw }"
	powershell -Command "$$ErrorActionPreference = 'Stop'; Remove-Item -Force -Recurse $(BUILD_RESULTS_DIR)/temp"
