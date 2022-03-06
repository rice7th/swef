# swef

The Should Work Everywhere Fetch.

![Maintenance](https://img.shields.io/maintenance/yes/2022?style=for-the-badge)
![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/jhonnyrice/swef?style=for-the-badge)
![GitHub release (latest by date)](https://img.shields.io/github/v/release/jhonnyrice/swef?style=for-the-badge)


![image](https://user-images.githubusercontent.com/93940240/152065374-8f0b0ede-d2d7-4d94-a502-4368cd1eee56.png)

Example of the fetch on ubuntu

Written mainly in Lua, it is a generic fetch that works everywhere, even on windows, without emulating stuff exclusive to unix, such as bash.
The only dependencies are Lua and xprop, but xprop is required only on x11 systems, meaning that you dont need it for android, MacOs, windows and wayland systems. Also Xprop is usually preinstalled, but double-checking never hurts :)

## Installation
Download the package (Linux/MacOS only):
```
luarocks install swef
```
Clone the repo if your system does not support LuaRocks, or if you are on Windows:
```
git clone https://github.com/JhonnyRice/swef
```
Then build it in these ways, depending on the system:

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
chmod +x src/swef
cp src/swef /data/data/com.termux/files/usr/bin
```

#### Windows
run the file every time you want to use it i think
```
lua53 C:\path\to\swef
``` 
or use a batch file idk
```batch
lua53 C:\path\to\swef
```
and then run the batch file:
```
C:\path\to\batch_file.bat
```
also note that you can move the batchfile into C:\Program Files\swef\ and it will run as a program

replace lua53 with your current lua version: e.g.  if you have lua 5.4 installed, replace `lua53` with `lua54`

## Effectiveness
The fetch (as the name suggests) SHOULD work everywhere; These are the places where i tested it:

![Kubuntu](https://i.imgur.com/DVcna4O.png)

- [x] Kubuntu 20.04 (Kde, X11, AwesomeWM)
---
![Fedora](https://i.imgur.com/tE7kDNY.png)

- [x] Fedora 35 (Gnome, Wayland, Mutter)
---
![Alpine Linux](https://i.imgur.com/I5uZY5j.png)

- [x] Alpine Linux 3.15 (none, tty, none)
---
![Void Linux](https://i.imgur.com/PxxPeFM.png)

- [x] Void Linux (none, x11, AwesomeWM)
---
- [x] Windows 10 Pro (Metro, ??, Explorer)
- [x] Android 9 (Material, ??, are there WMs for android?)
- [x] MacOS Big Sur (Aero, Quartz, Quartz Compositor)
---
![Haiku](https://i.imgur.com/rdydTVJ.png)

- [x] Haiku (??, ??, ??)
---
- [x] FreeBSD (none, tty, none)

Places to test:
- [ ] OtherBSDs
- [ ] Older Windows versions
- [ ] Plan 9 (Should work)

Places where it does NOT work:
- [ ] AIX
- [ ] MINIX
- [ ] IRIX
- [ ] FreeMiNT
- [ ] Inferno
- [ ] BeOS (original)

For the rest it should work fine on tons of platforms. At least where Lua is supported, and Lua is built in ANSI C, meaning that it can be compiled everywhere.
If your os is not supported (e.g. no ascii available or the os is not recognised) you can enjoy a cute cat art that changes breeed randomly as a replacement. If you REALLY want a new ascii art for your system, then please submit a github issue.
## Features
- [x] OS name
- [x] Window Manager ~(Non EWMH wm's are comin!)~ Non EWMH linux wm's are here, plus MacOS and Windows WM's support!
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

xprop (dunno)

Thats it.

Thanks for using swef.
