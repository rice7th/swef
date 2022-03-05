package = "swef"
version = "1-3"
source = {
   url = "git+https://github.com/JhonnyRice/swef.git",
   tag = "1.3"
}
description = {
   summary = "The Should Work Everywhere Fetch",
   detailed = [[
      ![image](https://user-images.githubusercontent.com/93940240/152065374-8f0b0ede-d2d7-4d94-a502-4368cd1eee56.png)
      SWEF is a fetching tool just like neofetch or pfetch, with just one goal: being supported on the largest number of platforms.
      Neofetch Works easly on Linux, Haiku, AIX, FreeBSD and other BSDs, FreeMiNT, IRIX, MacOS, Windows (Using CygWIN) and Android (Using termux).
      SWEF is work in progress, but already supports Linux, Haiku, MacOS, Windows, Android (Using termux) and theorically Plan9 (installing lu9 or compiling lua manually; hope that version 5.1+ works; NOT TESTED).
      Tesded OSes are:
      - Kubuntu 20.04
      - Fedora 35
      - Alpine Linux 3.15
      - Windows 10 progress
      - Android 9 (Termux 0.118.1)
      - MacOS Big Sur
      - FreeBSD
      - Void Linux
      
      OSes where is SHOULD work:
      - Plan9/9Front

      NOT tested OSes:
      - BeOS
      - AmigaOS
   ]],
   homepage = "https://github.com/JhonnyRice/swef",
   license = "MIT"
}
dependencies = {
   "lua >= 5.3"
}
build = {
   type = "make"
}
