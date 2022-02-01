# swef
The Should Work Everywhere Fetch.h.

Written mainly in Lua, it is a generic fetch that works everywhere, even on windows, without emulating stuff exclusive to unix, such as bash.
The only dependency is Lua. At the moment, the only way to actually use the fetch is by typing:
```
lua swef.lua
```
The fetch (as the name suggests) SHOULD work everywhere; These are the places where i tested it:

- [x] Kubuntu 20.04 (Kde, X11, AwesomeWM)
- [x] Fedora 35 (Gnome, Wayland, Mutter)
- [x] Alpine Linux 3.15 (none, tty, none)
- [x] Windows 10 Pro (Metro, ??, Explorer)
- [x] Android 9 (Material, ??, are there WMs for android?)
- [x] MacOS Big Sur (Aero, Quartz, Quartz Compositor)

Places to test:
- [ ] Any BSD
- [ ] Older Windows versions

For the rest it should work fine on tons of platforms. At least where Lua is supported, and Lua is built in ANSI C, meaning that it can be compiled everywhere.

## Features
- [x] OS name
- [x] Window Manager
- [x] Kernel
- [x] Shell (bugged :v)

Maybe in the future:
- [ ] Hostname
- [ ] User
- [ ] CPU
- [ ] RAM
- [ ] Disk space

## Dependences
Lua: https://www.lua.org/download.html

Thats it.

Thanks for using swef.
