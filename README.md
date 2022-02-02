# swef
The Should Work Everywhere Fetch.

![image](https://user-images.githubusercontent.com/93940240/152065374-8f0b0ede-d2d7-4d94-a502-4368cd1eee56.png)

Example of the fetch on ubuntu

Written mainly in Lua, it is a generic fetch that works everywhere, even on windows, without emulating stuff exclusive to unix, such as bash.
The only dependencies are Lua and xprop, but xprop is required only on x11 systems, meaning that you dont need it for android, MacOs, windows and wayland systems. Also Xprop is usually preinstalled, but double-checking never hurts :)

## Installation
#### Linux
use the makefile:
```
sudo make install
```

#### MacOS
again use the makefile:
```
sudo make install
```
#### Android
```
chmod +x ./swef.lua
cp ./swef.lua /data/data/com.termux/files/usr/bin
```

#### Windows
run the file every time you want to use it i think
```
lua<version> C:\path\to\swef.lua
```

## Effectiveness
The fetch (as the name suggests) SHOULD work everywhere; These are the places where i tested it:

![Kubuntu](https://user-images.githubusercontent.com/93940240/152065374-8f0b0ede-d2d7-4d94-a502-4368cd1eee56.png)

- [x] Kubuntu 20.04 (Kde, X11, AwesomeWM)
---
![Fedora](https://user-images.githubusercontent.com/93940240/152212814-08a44df8-3f23-40ea-ae58-f35898ed3aa7.png)

- [x] Fedora 35 (Gnome, Wayland, Mutter)
---
- [x] Alpine Linux 3.15 (none, tty, none)
- [x] Windows 10 Pro (Metro, ??, Explorer)
- [x] Android 9 (Material, ??, are there WMs for android?)
- [x] MacOS Big Sur (Aero, Quartz, Quartz Compositor)

Places to test:
- [ ] Any BSD (freeBSD kinda works)
- [ ] Older Windows versions

For the rest it should work fine on tons of platforms. At least where Lua is supported, and Lua is built in ANSI C, meaning that it can be compiled everywhere.
If your os is not supported (e.g. no ascii available or the os is not recognised) you can enjoy a cute cat art that changes breeed randomly as a replacement. If you REALLY want a new ascii art for your system, then please submit a github issue.
## Features
- [x] OS name
- [x] Window Manager (EWMH wm's are comin!)
- [x] Kernel
- [x] Shell ~(bugged :v)~ fixed 👌

Maybe in the future:
- [ ] Hostname
- [ ] User
- [ ] CPU
- [ ] RAM
- [ ] Disk space

## Dependences
Lua: https://www.lua.org/download.html

xprop

Thats it.

Thanks for using swef.
