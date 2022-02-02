PREFIX?=/usr

installmacos:
	cp -f swef $(PREFIX)/bin/swef
	chmod 755 $(PREFIX)/bin/swef
install:
	cp -f swef $(PREFIX)/bin/swef
	chmod 755 $(PREFIX)/bin/swef
uninstall:
	rm -f $(PREFIX)/bin/swef

.PHONY: installmacos install uninstall
