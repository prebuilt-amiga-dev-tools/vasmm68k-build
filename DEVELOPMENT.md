
# Updating to a new vasm version

Create a new branch. Modify the contents of [Config.mk](Config.mk). Try building using `make` (Linux) / `nmake` (Windows). Submit a pull request.

# Releasing a new version

Once a [Config.mk](Config.mk) has been updated on `master`, pull that branch. Ensure you have no local changes, and nothing to pull/push. Trigger the release by performing `make release` (must be done under Linux).