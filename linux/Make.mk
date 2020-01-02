
# Unix build script

include Config.mk

ifeq ($(strip $(DISTRIBUTION)),)
DISTRIBUTION := unknown
endif

# Ensure that VASM_URL, VASM_DOC_URL and VASM_VERSION can be overridden
#  through the use of NEW_xxx environment variables.
# These variables are used when calling 'make update-config'.

ifneq ($(strip $(NEW_VASM_URL)),)
VASM_URL = $(NEW_VASM_URL)
endif

ifneq ($(strip $(NEW_VASM_DOC_URL)),)
VASM_DOC_URL = $(NEW_VASM_DOC_URL)
endif

ifneq ($(strip $(NEW_VASM_VERSION)),)
VASM_VERSION = $(NEW_VASM_VERSION)
endif


BUILD_RESULTS_DIR = build_results

.PHONY: clean download build package-deb test-deb update-homebrew-formula-locally test-homebrew-formula

default: clean download build package-deb test-deb update-homebrew-formula-locally test-homebrew-formula

.PHONY: install-deb uninstall-deb extract-changelog release

######################################################################################
# These build steps are intended to be invoked manually with make

clean:
	./linux/scripts/clean.sh "$(BUILD_RESULTS_DIR)"

download:
	./linux/scripts/download.sh "$(VASM_URL)" "$(VASM_DOC_URL)"

build:
	./linux/scripts/build.sh

package-deb:
	./linux/scripts/package-deb.sh "$(BUILD_RESULTS_DIR)" "$(VASM_VERSION)" "$(DISTRIBUTION)"

test-deb:
	./linux/scripts/test-deb.sh "$(BUILD_RESULTS_DIR)" "$(VASM_VERSION)" "$(DISTRIBUTION)"

extract-changelog:
	./linux/scripts/extract-changelog.sh "$(BUILD_RESULTS_DIR)" "$(VASM_VERSION)"

######################################################################################
# These build steps are not part of the build/package process; they allow for
# easy local testing of a newly-built .deb package

install-deb:
	./linux/scripts/install-deb.sh "$(BUILD_RESULTS_DIR)" "$(VASM_DVERSION)" "$(DISTRIBUTION)"

uninstall-deb:
	./linux/scripts/uninstall-deb.sh

######################################################################################
# These steps are part of the automated release process; they modify
#  the Git repository and push to origin

update-config:
	./linux/scripts/update-config.sh "$(NEW_VASM_URL)" "$(NEW_VASM_DOC_URL)" "$(NEW_VASM_VERSION)"

release:
	./linux/scripts/release.sh "$(VASM_VERSION)"

######################################################################################

include homebrew/Make.mk
