# swef

The Should Work Everywhere Fetch.

![Maintenance](https://img.shields.io/maintenance/yes/2022?style=for-the-badge)
![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/jhonnyrice/swef?style=for-the-badge)
![GitHub release (latest by date)](https://img.shields.io/github/v/release/jhonnyrice/swef?style=for-the-badge)


![image](https://user-images.githubusercontent.com/93940240/152065374-8f0b0ede-d2d7-4d94-a502-4368cd1eee56.png)

Example of the fetch on ubuntu

Written mainly in Lua, SWEF is a generic system fetch that works (nearly) everywhere, even on windows, without emulating shells or using some weird compatibility layes.
The only dependencies are Lua (5.1+) and xprop, but xprop is required only on X11 systems, meaning that you dont need it for android, MacOs, windows and wayland systems. Also Xprop is usually preinstalled on X11 systems, but double-checking never hurts :)

## Installation
Download the package (Linux/MacOS only):
```
luarocks install swef
```
Clone the repo if your system does not support LuaRocks, or if you are on Windows:
```
git clone https://github.com/JhonnyRice/swef
```
Then ~~build~~ install it in these ways, depending on the system:

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
Make sure to use Termux.
```
pkg install lua # or luajit
git clone https://github.com/JhonnyRice/swef/
cd swef
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

#### 9Front/Plan9
I could not believe i've managed to do this...

first, grab git. If you are on 9Front it is preinstalled, otherwise you should download [git9](https://github.com/oridb/git9) by Oridb.
Next, install Lu9, Lua with full plan9/9front support. You can read the instructions [here](https://github.com/okvik/lu9)
Finally, clone this repo and run swef:
```
git/clone https://github.com/jhonnyrice/swef/
cd swef/src
lu9 swef -n
```
Escape codes are not supported on plan9/9front, so make sure to run swef with the `-n` or the `--no-color` flag to avoid fancy issues.

## Effectiveness
The fetch (as the name suggests) SHOULD work everywhere; These are the places where i tested it:

![Kubuntu](https://i.imgur.com/DVcna4O.png)

- [x] Kubuntu 20.04 (Kde, X11, AwesomeWM)
---
![Fedora](https://i.imgur.com/tE7kDNY.png)

- [x] Fedora 35 (Gnome, Wayland, Mutter)
---
![Alpine Linux](https://i.imgur.com/I5uZY5j.png)

- [x] Alpine Linux 3.15 (XFCE, X11, XFWM4)
---
![Void Linux](https://i.imgur.com/PxxPeFM.png)

- [x] Void Linux (none, x11, AwesomeWM)
---
![Windows 10](https://i.imgur.com/BVvqYSv.png)

- [x] Windows 10 Pro (Metro, ??, Explorer)
---
![Andorid 9](https://i.imgur.com/LHXRThi.png)

- [x] Android 9 (Material, ??, are there WMs for android?)

---
![MacOS BigSur](https://i.imgur.com/A9ccKWf.png)

- [x] MacOS Big Sur (Aero, Quartz, Quartz Compositor)
---
![Haiku](https://i.imgur.com/rdydTVJ.png)

- [x] Haiku (??, ??, ??)
---
- [x] FreeBSD (none, tty, none)

---
![9Front](https://user-images.githubusercontent.com/93940240/166825130-97a2dbde-3648-4d49-b835-1bebcd5f21e1.png)

- [x] Plan9/9Front :v

---

#### Tested and supported platforms:
- [x] Windows
- [x] MacOS
- [x] Linux: both GNU and Busybox and both GLibC and Musl
- [x] Android (requires Termux)
- [x] Haiku
- [x] Plan9
- [x] 9Front
- [x] FreeBSD (no ascii tho)
- [x] NetBSD

#### Platforms where it should work:
a checked box means there is support but it has not been tested at all.
- [ ] OpenBSD
- [ ] DragonflyBSD
- [ ] MidnightBSD
- [ ] HarveyOS
- [ ] AIX
- [ ] MINIX
- [ ] IRIX
- [ ] FreeMiNT
- [ ] Inferno
- [ ] BeOS (original)
- [ ] OS/2
- [ ] ArcaOS
- [ ] AmigaOS
- [x] MorphOS
- [ ] SerenityOS
- [ ] iOS (via OpenTerm i guess?)
- [ ] iPadOS (same as iOS)


#### Platforms where it does NOT work (or it should not):
- [ ] Redox (we have hope since we have an actual rust lua interpreter)
- [ ] BlackBerry OS
- [ ] TempleOS (unless someone writes a lua interpreter in holyc i dont see that coming)

For the rest it should work fine on tons of platforms. At least where Lua is supported, and Lua is built in ANSI C, meaning that it can be compiled nearly everywhere, with some patches.
If your os is not supported (e.g. no ascii available or the os is not recognised) you can enjoy a cute cat art that changes breeed randomly as a replacement. If you REALLY want a new ascii art for your system, then please submit a github issue.
## Features
- [x] OS name
- [x] Window Manager ~(Non EWMH wm's are comin!)~ Non EWMH linux wm's are here, plus MacOS, FreeMiNT and Windows WM's support!
- [x] Kernel
- [x] Shell 👌

**Maybe** in the future:
- [x] Hostname
- [x] User
- [x] CPU
- [x] RAM
- [x] Disk space
- [x] Uptime
- [ ] Package Number
- [ ] ???

## Dependences
Lua: https://www.lua.org/download.html

xprop (only for X11 systems, e.g. Linux w/ X11, FreeBSD, NetBSD, OpenBSD, Minix etc)

Thats it.

Thanks for using swef.
