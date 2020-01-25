
.PHONY : update-homebrew-formula-locally update-homebrew-formula-and-push install-homebrew-formula uninstall-homebrew-formula test-homebrew-formula

######################################################################################
# These build steps are intended to be invoked manually with make

update-homebrew-formula-locally:
ifeq ($(strip $(BUILD_TYPE)),RELEASE)
	./homebrew/scripts/update-homebrew-formula.sh "$(VASM_URL)" "$(VASM_VERSION)" false
else
	echo "Skipping homebrew formula update for NIGHTLY build type"
endif

test-homebrew-formula:
	./homebrew/scripts/test-homebrew-formula.sh "$(BUILD_TYPE)"

######################################################################################
# These build steps are not part of the build process; they allow for
# easy local testing of the formula

install-homebrew-formula:
	./homebrew/scripts/install-homebrew-formula.sh

uninstall-homebrew-formula:
	./homebrew/scripts/uninstall-homebrew-formula.sh

######################################################################################
# These steps are part of the automated release process; they modify
#  the Git repository, push to origin and create a pull request

update-homebrew-formula-and-create-pr:
	./homebrew/scripts/update-homebrew-formula.sh "$(VASM_URL)" "$(VASM_VERSION)" true
