PREFIX?=/usr

install:
	cp -f src/swef $(PREFIX)/bin/swef
	chmod 755 $(PREFIX)/bin/swef
uninstall:
	rm -f $(PREFIX)/bin/swef

.PHONY: install uninstall
