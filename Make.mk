
# Unix build script

include Config.mk

BUILD_RESULTS_DIR = build_results

.PHONY: clean download build install uninstall

default: debuild package

######################################################################################
# These build steps are intended to be invoked manually with make

debuild:
	sudo DEBUILD_DPKG_BUILDPACKAGE_OPTS="-r'fakeroot --faked faked-tcp' -us -uc" DEBUILD_LINTIAN_OPTS="-i -I --show-overrides" sudo debuild --no-conf -us -uc

package:
	mkdir -p $(BUILD_RESULTS_DIR)
	cp ../vasmm68k_*_amd64.deb $(BUILD_RESULTS_DIR)
	(cd $(BUILD_RESULTS_DIR) && tar -cvf linux-deb-package.tgz vasmm68k_*_amd64.deb)
	rm $(BUILD_RESULTS_DIR)/vasmm68k_*_amd64.deb

######################################################################################
# These build steps are not part of the build/package process; they allow for
# easy local testing of a newly-built vasm without needing to install the .deb package

install:
	mkdir -p $(DESTDIR)/usr/bin
	cp vasm/vasmm68k_mot $(DESTDIR)/usr/bin/
	chmod ugo+rx $(DESTDIR)/usr/bin/vasmm68k_mot

	cp vasm/vasmm68k_std $(DESTDIR)/usr/bin/
	chmod ugo+rx $(DESTDIR)/usr/bin/vasmm68k_std

uninstall:
	rm -f /usr/bin/vasmm68k_mot
	rm -f /usr/bin/vasmm68k_std

######################################################################################
# These build steps will be invoked by the 'debuild' tool; they are referenced in the debian/rules file
# They can also be invoked manually with make

clean:
	rm -rf vasm
	rm -f vasm.tar.gz

download:
	wget -O vasm.tar.gz $(VASM_URL)
	tar -xvf vasm.tar.gz
	rm vasm.tar.gz

build:
	(cd vasm && make CPU=m68k SYNTAX=mot && chmod ugo+rx vasmm68k_mot)
	(cd vasm && make CPU=m68k SYNTAX=std && chmod ugo+rx vasmm68k_std)

