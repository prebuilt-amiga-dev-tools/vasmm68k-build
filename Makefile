
default: build

.PHONY: clean download build install uninstall

clean:
	rm -rf vasm

download:
	wget -O vasm.tar.gz $(URL)
	tar -xvf vasm.tar.gz
	rm vasm.tar.gz

build:
	(cd vasm && make CPU=m68k SYNTAX=mot && chmod ugo+rx vasmm68k_mot)
	(cd vasm && make CPU=m68k SYNTAX=std && chmod ugo+rx vasmm68k_std)

install:
	cp vasm/vasmm68k_mot $(DESTDIR)
	chmod ugo+rx $(DESTDIR)/vasmm68k_mot

	cp vasm/vasmm68k_std $(DESTDIR)
	chmod ugo+rx $(DESTDIR)/vasmm68k_std

uninstall:
	rm -f /usr/bin/vasmm68k_mot
	rm -f /usr/bin/vasmm68k_std
