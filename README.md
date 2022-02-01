# swef
The Should Work Everywhere Fetch.

![image](https://user-images.githubusercontent.com/93940240/152065374-8f0b0ede-d2d7-4d94-a502-4368cd1eee56.png)

Example of the fetch on ubuntu

Written mainly in Lua, it is a generic fetch that works everywhere, even on windows, without emulating stuff exclusive to unix, such as bash.
The only dependency is Lua. To start it on unix systems, you can jut type the path to swef:
```
/path/to/swef
```
On windows unfortunately the shebang is not a thing yet, so you need to open it with lua:
```
lua /path/to/swef
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
If your os is not supported (e.g. no ascii available or the os is not recognised) you can enjoy a cute cat art that changes breeed randomly as a replacement. If you REALLY want a new ascii art for your system, then please submit a github issue.
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
