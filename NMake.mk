
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
	powershell -File scripts/windows/clean.ps1 -VASMDIR "$(VASMDIR)" -BUILD_RESULTS_DIR "$(BUILD_RESULTS_DIR)"

download:
	powershell scripts/windows/download.ps1 -VASM_URL "$(VASM_URL)"

build:
	powershell scripts/windows/build.ps1 -VASMDIR "$(VASMDIR)"

package-binaries:
	powershell scripts/windows/package-binaries.ps1 -VASMDIR "$(VASMDIR)" -BUILD_RESULTS_DIR "$(BUILD_RESULTS_DIR)" -VASM_VERSION "$(VASM_VERSION)"

package-wix:
	powershell scripts/windows/package-wix.ps1 -VASMDIR "$(VASMDIR)" -BUILD_RESULTS_DIR "$(BUILD_RESULTS_DIR)" -VASM_VERSION "$(VASM_VERSION)"

package-choco:
	powershell scripts/windows/package-choco.ps1 -VASMDIR "$(VASMDIR)" -BUILD_RESULTS_DIR "$(BUILD_RESULTS_DIR)" -VASM_VERSION "$(VASM_VERSION)"

test-binaries:
	powershell scripts/windows/test-binaries.ps1 -BUILD_RESULTS_DIR "$(BUILD_RESULTS_DIR)" -VASM_VERSION "$(VASM_VERSION)"

test-wix:
	powershell scripts/windows/test-wix.ps1 -BUILD_RESULTS_DIR "$(BUILD_RESULTS_DIR)" -VASM_VERSION "$(VASM_VERSION)"

test-choco:
	powershell scripts/windows/test-choco.ps1 -BUILD_RESULTS_DIR "$(BUILD_RESULTS_DIR)" -VASM_VERSION "$(VASM_VERSION)"
