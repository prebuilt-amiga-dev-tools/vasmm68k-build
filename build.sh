

# install pbuilder
sudo apt-get install pbuilder debootstrap devscripts

# install dh
sudo apt-get install debhelper

# install vasm-package-specific tools (which are these?)

# build package; do not sign changes etc
DEBUILD_DPKG_BUILDPACKAGE_OPTS="-r'fakeroot --faked faked-tcp' -us -uc"
DEBUILD_LINTIAN_OPTS="-i -I --show-overrides"
debuild --no-conf -us -uc


