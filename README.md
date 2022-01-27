# swef
SWEF (Should Work Everywhere Fetch) is a minimal, fast and generic fetching program that is ultra-lightweight (~80 lines of code) and SHOULD work on Linux, MacOS and Android. Probably written in POSIX shell, it gives you little to none info, but at least that info is accurate. Maybe.

## Features
- [x] OS/Distro fetch;
- [x] Kernel name and release;
- [x] Currently running shell (Only Android and Linux), otherwise default shell;
- [x] Window Manager Fetch (supports X11, Wayland and MacOS, tho i stealed that part from neofetch);

### Maybe in the future
- [ ] Color support;
- [ ] CPU fetch;
- [ ] Uptime;
- [ ] Graphic session;
- [ ] User fetch (hostname, nodename, things that the user sets on its own like messages, quotes, etc.)

## Installation
use make:

Linux
```sh
sudo make install #installs
sudo make uninstall #uninstalls
```
MacOS
```sh
sudo make installmacos #installs
sudo make uninstall #uninstalls
```
Android (soon)
