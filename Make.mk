
# Unix build script

include Config.mk

ifeq ($(strip $(DISTRIBUTION)),)
DISTRIBUTION := unknown
endif

BUILD_RESULTS_DIR = build_results

.PHONY: clean download build package test

default: clean download build package test

.PHONY: install test-deb install-deb remove-deb release

######################################################################################
# These build steps are intended to be invoked manually with make

clean:
	rm -rf vasm
	rm -f vasm.tar.gz
	rm -rf $(BUILD_RESULTS_DIR)

download:
	wget -O vasm.tar.gz $(VASM_URL)
	tar -xvf vasm.tar.gz
	rm vasm.tar.gz

build:
	(cd vasm && make CPU=m68k SYNTAX=mot && chmod ugo+rx vasmm68k_mot)
	(cd vasm && make CPU=m68k SYNTAX=std && chmod ugo+rx vasmm68k_std)

package: package-deb

package-deb:
	sudo DEBUILD_DPKG_BUILDPACKAGE_OPTS="-r'fakeroot --faked faked-tcp' -us -uc" DEBUILD_LINTIAN_OPTS="-i -I --show-overrides" debuild --no-conf -us -uc
	mkdir -p $(BUILD_RESULTS_DIR)
	cp ../vasmm68k_$(VASM_VERSION)_amd64.deb $(BUILD_RESULTS_DIR)/vasmm68k_$(VASM_VERSION)_amd64.$(DISTRIBUTION).deb

test: test-deb

test-deb:
	sudo dpkg -i $(BUILD_RESULTS_DIR)/vasmm68k_$(VASM_VERSION)_amd64.$(DISTRIBUTION).deb

	mkdir -p $(BUILD_RESULTS_DIR)/temp

	vasmm68k_mot -Fhunk -o $(BUILD_RESULTS_DIR)/temp/test_mot.o tests/test_mot.s && cmp tests/test_mot.o.expected $(BUILD_RESULTS_DIR)/temp/test_mot.o || exit 1
	vasmm68k_std -Fhunk -o $(BUILD_RESULTS_DIR)/temp/test_std.o tests/test_std.s && cmp tests/test_std.o.expected $(BUILD_RESULTS_DIR)/temp/test_std.o || exit 1
	vobjdump tests/test_vobjdump.o > $(BUILD_RESULTS_DIR)/temp/test_vobjdump.dis && cmp tests/test_vobjdump.dis.expected $(BUILD_RESULTS_DIR)/temp/test_vobjdump.dis || exit 1

	rm -rf $(BUILD_RESULTS_DIR)/temp

	sudo dpkg -r vasmm68k

release:
	./release.sh $(VASM_VERSION)

######################################################################################
# These build steps are not part of the build/package process; they allow for
# easy local testing of a newly-built .deb package

install-deb:
	sudo dpkg -i $(BUILD_RESULTS_DIR)/vasmm68k_$(VASM_VERSION)_amd64.$(DISTRIBUTION).deb

remove-deb:
	sudo dpkg -r vasmm68k

######################################################################################
# These build steps will be invoked by the 'debuild' tool; they are referenced in the debian/rules file
# They can also be invoked manually with make

install:
	mkdir -p $(DESTDIR)/usr/bin

	cp vasm/vasmm68k_mot $(DESTDIR)/usr/bin/
	chmod ugo+rx $(DESTDIR)/usr/bin/vasmm68k_mot

	cp vasm/vasmm68k_std $(DESTDIR)/usr/bin/
	chmod ugo+rx $(DESTDIR)/usr/bin/vasmm68k_std

	cp vasm/vobjdump $(DESTDIR)/usr/bin/
	chmod ugo+rx $(DESTDIR)/usr/bin/vobjdump
