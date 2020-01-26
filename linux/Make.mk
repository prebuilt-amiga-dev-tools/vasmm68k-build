
# Unix build script

include Config.mk

# DISTRIBUTION defaults to unknown

ifeq ($(strip $(DISTRIBUTION)),)
DISTRIBUTION := unknown
endif

# BUILD_TYPE defaults to NIGHTLY

ifeq ($(strip $(BUILD_TYPE)),)
BUILD_TYPE := NIGHTLY
endif

# Setup VASM_URL and VASM_VERSION to refer to either the release or nightly build

ifeq ($(strip $(BUILD_TYPE)),RELEASE)
VASM_URL := $(VASM_RELEASE_URL)
VASM_VERSION := $(VASM_RELEASE_VERSION)
else ifeq ($(strip $(BUILD_TYPE)),NIGHTLY)
VASM_URL := $(VASM_NIGHTLY_URL)
# It would be nice if we could have VASM_VERSION = "0.0.0" for nightly builds.
# However, the .deb packaging flow does not have access to BUILD_TYPE or any local
#  variables from Make.mk. Therefore, we use VASM_RELEASE_VERSION to keep
#  the versioning consistent.
VASM_VERSION := $(VASM_RELEASE_VERSION)
else
$(error BUILD_TYPE must be undefined, or set to NIGHTLY or RELEASE)
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
	./linux/scripts/update-config.sh "$(NEW_VASM_RELEASE_URL)" "$(NEW_VASM_RELEASE_VERSION)"

release:
	./linux/scripts/release.sh "$(VASM_VERSION)"

######################################################################################

include homebrew/Make.mk
