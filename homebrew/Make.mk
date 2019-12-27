
.PHONY : update-homebrew-formula-locally update-homebrew-formula-and-push install-homebrew-formula uninstall-homebrew-formula test-homebrew-formula

######################################################################################

update-homebrew-formula-locally:
	./homebrew/scripts/update-homebrew-formula.sh "$(NEW_VASM_URL)" "$(NEW_VASM_VERSION)" false

update-homebrew-formula-and-push:
	./homebrew/scripts/update-homebrew-formula.sh "$(NEW_VASM_URL)" "$(NEW_VASM_VERSION)" true

install-homebrew-formula:
	./homebrew/scripts/install-homebrew-formula.sh

uninstall-homebrew-formula:
	./homebrew/scripts/uninstall-homebrew-formula.sh

test-homebrew-formula:
	./homebrew/scripts/test-homebrew-formula.sh
