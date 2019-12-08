
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
	powershell -File windows/scripts/clean.ps1 -VASMDIR "$(VASMDIR)" -BUILD_RESULTS_DIR "$(BUILD_RESULTS_DIR)"

download:
	powershell windows/scripts/download.ps1 -VASM_URL "$(VASM_URL)" -VASM_DOC_URL "$(VASM_DOC_URL)"

build:
	powershell windows/scripts/build.ps1 -VASMDIR "$(VASMDIR)"

package-binaries:
	powershell windows/scripts/package-binaries.ps1 -VASMDIR "$(VASMDIR)" -BUILD_RESULTS_DIR "$(BUILD_RESULTS_DIR)" -VASM_VERSION "$(VASM_VERSION)"

package-wix:
	powershell windows/scripts/package-wix.ps1 -VASMDIR "$(VASMDIR)" -BUILD_RESULTS_DIR "$(BUILD_RESULTS_DIR)" -VASM_VERSION "$(VASM_VERSION)"

package-choco:
	powershell windows/scripts/package-choco.ps1 -VASMDIR "$(VASMDIR)" -BUILD_RESULTS_DIR "$(BUILD_RESULTS_DIR)" -VASM_VERSION "$(VASM_VERSION)"

test-binaries:
	powershell windows/scripts/test-binaries.ps1 -BUILD_RESULTS_DIR "$(BUILD_RESULTS_DIR)" -VASM_VERSION "$(VASM_VERSION)"

test-wix:
	powershell windows/scripts/test-wix.ps1 -BUILD_RESULTS_DIR "$(BUILD_RESULTS_DIR)" -VASM_VERSION "$(VASM_VERSION)"

test-choco:
	powershell windows/scripts/test-choco.ps1 -BUILD_RESULTS_DIR "$(BUILD_RESULTS_DIR)" -VASM_VERSION "$(VASM_VERSION)"
