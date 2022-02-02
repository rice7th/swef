PREFIX?=/usr

install:
	cp -f swef $(PREFIX)/bin/swef
	chmod 755 $(PREFIX)/bin/swef
uninstall:
	rm -f $(PREFIX)/bin/swef

.PHONY: install uninstall
