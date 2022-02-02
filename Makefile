PREFIX?=/usr

installmacos:
	cp -f swef.lua $(PREFIX)/bin/swef.lua
	chmod 755 $(PREFIX)/bin/swef.lua
install:
	cp -f swef.lua $(PREFIX)/bin/swef.lua
	chmod 755 $(PREFIX)/bin/swef.lua
uninstall:
	rm -f $(PREFIX)/bin/swef.lua

.PHONY: installmacos install uninstall
