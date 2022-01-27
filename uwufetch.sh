#!/usr/bin/env bash
KERNEL=$(uname)
KERNEL_REL=$(uname -r)
SHELL_NAME=$(cat /proc/$$/comm) # how does this even work
case ${KERNEL,,} in
    linux)
        OS_TYPE=$(uname -o)
        case ${OS_TYPE,,} in
            "gnu/linux")
                # OS/Distro
                OS_NAME_CHECK=$(grep -m1 "NAME=" < /etc/os-release | grep '"') #checks if " is contenuted in the line of NAME=.
                if [[ -z "$OS_NAME_CHECK" ]]
                then
                    OS=$(grep -m1 "NAME=" < /etc/os-release)
                    OS=${OS:5}
                else
                    OS=$(grep -m1 "NAME=" < /etc/os-release | cut -d '"' -f 2)
                fi

                # Shell
                if [[ ! -d "/proc/" ]]
                then
                    SHELL_NAME=$SHELL
                fi

                # Window Manager
                if [[ ${XDG_SESSION_TYPE,,} == "x11" ]]
                then
                    WM=$(xprop -id "$(xprop -root _NET_SUPPORTING_WM_CHECK | cut -d' ' -f5)" _NET_WM_NAME | cut -d'"' -f2)
                elif [[ ${XDG_SESSION_TYPE,,} == "wayland" ]]
                then
                    WM=$(ps -e | grep -m 1 -oi "arcan\|asc\|clayland\|dwc\|fireplace\|gnome-shell\|greenfield\|grefsen\|hikari\|kwin\|lipstick\|maynard\|mazecompositor\|motorcar\|orbital\|orbment\|perceptia\|river\|rustland\|sway\|ulubis\|velox\|wavy\|way-cooler\|wayfire\|wayhouse\|westeros\|westford\|weston\|gnome")
                    if [[ ${WM,,} == "gnome" ]]
                    then
                        WM="Mutter"
                    fi
                else
                    WM="Unknown :("
                fi
            ;;
            "android")
                OS="Android"
                WM="Android wm"
                SHELL_NAME=$(cat /proc/$$/comm)
            ;;
        esac
    ;;
    darwin)
        OS_VER=$(sw_vers | grep -i "ProductVersion:")
        OS="MacOS ${OS_VER:16}"
        WM=$(ps -e | grep -o \
                    -e "[S]pectacle" \
                    -e "[A]methyst" \
                    -e "[k]wm" \
                    -e "[c]hun[k]wm" \
                    -e "[y]abai" \
                    -e "[R]ectangle")
        case $WM in
            *chunkwm*)   wm=chunkwm ;;
            *kwm*)       wm=Kwm ;;
            *yabai*)     wm=yabai ;;
            *Amethyst*)  wm=Amethyst ;;
            *Spectacle*) wm=Spectacle ;;
            *Rectangle*) wm=Rectangle ;;
            *)           wm="Quartz Compositor" ;;
        esac
        SHELL_NAME=$SHELL

        ;;
esac

printf "Os: ${OS}\n"
printf "Wm: ${WM}\n"
printf "Sh: ${SHELL_NAME}\n"
printf "Kn: ${KERNEL} ${KERNEL_REL}\n"