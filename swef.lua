#!/usr/bin/env lua
--[[
    MIT License

    Copyright (c) 2022 JhonnyRice

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
]]

-- COLORS (B_ stands for BRIGHT_)

RED    = "\x1b[31m"
GREEN  = "\x1b[32m"
YELLOW = "\x1b[33m"
BLUE   = "\x1b[34m"
PURPLE = "\x1b[35m"
CYAN   = "\x1b[36m"

B_RED    = "\x1b[91m"
B_GREEN  = "\x1b[92m"
B_YELLOW = "\x1b[93m"
B_BLUE   = "\x1b[94m"
B_PURPLE = "\x1b[95m"
B_CYAN   = "\x1b[96m"


-- Monochromatic
BLACK  = "\x1b[30m"
GRAY   = "\x1b[90m"
B_GRAY  = "\x1b[37m"
WHITE   = "\x1b[97m"

-- Remove all colors
NOCOL = "\x1b[0m"

--[[ STOLEN FROM:: https://stackoverflow.com/a/40195356]]
-- Checks if a file exist
function exists(file)
    local ok, err, code = os.rename(file, file)
        if not ok then
            if code == 13 then
                return true
            end
        end
        return ok --, err
end
    

function isdir(path)
    return exists(path.."/")
end



function opencmd(cmd)
    local command = io.popen(cmd, "r")
    local command_output = command:read("*a")
    command:close()
    command_output = command_output:match("%C+")
    return command_output
end


function os_family()
    local os_family = package.config:sub(1,1)
    if os_family == "/" then
        return "unix"
    elseif os_family == "\\" then
        return "windows"
    end
end

function shell()
    does_proc_exist = isdir("/proc")
    if does_proc_exist then
        return opencmd("cat /proc/$$/comm")
    else
        return opencmd("basename $SHELL")
    end
end

function linux_wm()
    local graphic_session = os.getenv("XDG_SESSION_TYPE")
    if graphic_session ~= nil then
        if string.lower(graphic_session) == "x11" then
            return opencmd([[xprop -id "$(xprop -root _NET_SUPPORTING_WM_CHECK | cut -d' ' -f5)" _NET_WM_NAME | cut -d'"' -f2]])
        elseif string.lower(graphic_session) == "wayland" then
            local wm_pid_command = io.popen("ps -e")
            local wm_pids = string.lower(wm_pid_command:read("*a"))
            wm_pid_command:close()
            local wayland_wm_list = {
                "arcan",
                "asc",
                "clayland",
                "dwc",
                "fireplace",
                "gnome%-shell",
                "greenfield",
                "grefsen",
                "hikari",
                "kwin",
                "lipstick",
                "maynard",
                "mazecompositor",
                "motorcar",
                "orbital",
                "orbment",
                "perceptia",
                "river",
                "sway",
                "ulubis",
                "velox",
                "wavy",
                "way%-cooler",
                "wayfire",
                "wayhouse",
                "westeros",
                "westford",
                "weston"
            }
            for i=1,#wayland_wm_list,1 do
                wm = wm_pids:match(wayland_wm_list[i])
                if wm ~= nil then
                    if wm == "gnome-shell" then
                        return "mutter"
                    else
                        return wm
                    end
                end
            end
            if wm == nil then return os.getenv("WAYLAND_DISPLAY") end
        else
            wm = "unknown"
            return wm
        end
    else
        -- Graphic session is TTY
        wm = "tty"
        return wm
    end
end


function macos_wm()
    local wm_pid_command = io.popen("ps -e")
    local wm_pids = string.lower(wm_pid_command:read("*a"))
    wm_pid_command:close()
    local windows_wm_list = {
        "spectacle",
        "amethyst",
        "kwm",
        "chunkwm",
        "yabai",
        "rectangle"
    }
    for i=1,#windows_wm_list,1 do
        wm = wm_pids:match(windows_wm_list[i])
        if wm ~= nil then
            return wm
        end
    end
    if wm == nil then
        return "Quartz Compositor"
    end
end

function windows_wm()
    local wm_pid_command = io.popen("tasklist")
    local wm_pids = string.lower(wm_pid_command:read("*a"))
    wm_pid_command:close()
    local windows_wm_list = {
        "bugn",
        "windawesome",
        "blackbox",
        "emerge",
        "litestep",
        "explorer"
    }
    for i=1,#windows_wm_list,1 do
        wm = wm_pids:match(windows_wm_list[i])
        if wm ~= nil then
            return wm
        end
    end
end

function windows_version()
    local windows_ver = opencmd("wmic os get Caption /value")
    windows_ver = windows_ver:gsub("Caption=", '')
    return windows_ver
end

function distro()
    local distro_command = io.open("/etc/os-release", "r")
    local distro_temp = distro_command:read("*a")
    distro_command:close()
    local distro = distro_temp:match("NAME.%W?%w+", 1):gsub('"', ''):gsub('NAME=', '')
    return distro
end

function fetch()
    local os_type = os_family()
    if os_type == "unix" then
        -- Get Kernel name
        kern = opencmd("uname")

        -- Get Kernel release
        kern_release = opencmd("uname -r")

        -- Check if the kernel is linux, macos, bsd or other
        if string.lower(kern) == "linux" then
            linux_os = opencmd("uname -o")
            if string.lower(linux_os) == "android" then
                local fetch = {
                    os = "Android",
                    wm = "AndroidWM",
                    kn = kern .. kern_release,
                    sh = shell()
                }
                return fetch

            elseif string.lower(linux_os) == "gnu/linux" or "linux" then
                local fetch = {
                    os = distro(),
                    wm = linux_wm(),
                    kn = kern .. " " .. kern_release,
                    sh = shell()
                }
                return fetch
            else
                local fetch = {
                    os = ":(",
                    wm = ":(",
                    kn = ":(",
                    sh = ":("
                }
                return fetch
            end
        elseif string.lower(kern) == "darwin" then
            local fetch = {
                os = "Mac Os",
                wm = macos_wm(),
                kn = kern .. " " .. kern_release,
                sh = shell()
            }
            return fetch
        elseif string.lower(kern):match("MINGW64") == "mingw64" then
            local fetch = {
                os = "Windows (mingw)",
                wm = windows_wm(),
                kn = "mingw64",
                sh = shell()
            }
            return fetch
        else
            local fetch = {
                os = "Maybe BSD or Minix, this is still in WIP",
                wm = "¯\\_(ツ)_/¯",
                kn = "¯\\_(ツ)_/¯",
                sh = "¯\\_(ツ)_/¯"
            }
            return fetch
        end
    --[[ WINDOWS ]]
    elseif os_type == "windows" then
        local fetch = {
            os = windows_version(),
            wm = windows_wm(),
            kn = "NT",
            sh = "powershell"
        }
        return fetch
    else
        local fetch = {
            os = "you defeated me... (your os is CURRENTLY unsupported)",
            wm = "not sure",
            kn = "unknown",
            sh = "unknown"
        }
        return fetch
    end
end




function ascii(info, use_color) -- Boolean
    if use_color then
        if string.lower(info.os):match("ubuntu") then
            local ascii = {
                l1 = YELLOW .. "  /-".. B_RED .."'-" .. RED .. "( )       " .. NOCOL,
                l2 = B_RED .. "( )    |        " .. NOCOL,
                l3 = YELLOW .. "  \\-".. RED ..".-".. YELLOW .."( )       " .. NOCOL,
                l4 = NOCOL .. "                " .. NOCOL
            }
            return ascii
        elseif string.lower(info.os):match("arch") then
            local ascii = {
                l1 = CYAN .. "   /\\           " .. NOCOL,
                l2 = CYAN .. "  /\\ \\          " .. NOCOL,
                l3 = CYAN .. " / .. \\         " .. NOCOL,
                l4 = CYAN .. "/.'  '.\\        " .. NOCOL
            }
            return ascii
        elseif string.lower(info.os):match("gentoo") then
            local ascii = {
                l1 = B_GRAY .. " ,--.           " .. NOCOL,
                l2 = B_GRAY .. "( () \\          " .. NOCOL,
                l3 = B_GRAY .. " `^  /          " .. NOCOL,
                l4 = B_GRAY .. "  '~'           " .. NOCOL
            }
            return ascii
        elseif string.lower(info.os):match("fedora") then
            local ascii = {
                l1 = BLUE .. "   /¯¯\\         " .. NOCOL,
                l2 = BLUE .. " __|__          " .. NOCOL,
                l3 = BLUE .. "/  T            " .. NOCOL,
                l4 = BLUE .. "\\__/            " .. NOCOL
            }
            return ascii
        elseif string.lower(info.os):match("debian") then
            local ascii = {
                l1 = RED .. "    _.._        " .. NOCOL,
                l2 = RED .. "   (    |       " .. NOCOL,
                l3 = RED .. "   | (_/        " .. NOCOL,
                l4 = RED .. "    \\           " .. NOCOL
            }
            return ascii
        elseif string.lower(info.os):match("alpine") then
            local ascii = {
                l1 = BLUE .. " /¯¯¯¯¯¯\\       " .. NOCOL,
                l2 = BLUE .. "/  " .. WHITE .. "/\\/\\" .. BLUE .. "  \\      " .. NOCOL,
                l3 = BLUE .. "\\ " .. WHITE .. "/  \\ \\" .. BLUE .. " /      " .. NOCOL,
                l4 = BLUE .. " \\______/       " .. NOCOL
            }
            return ascii
        
        elseif string.lower(info.os):match("windows") then
            local ascii = {
                l1 = '|"""---....     ',
                l2 = '|____|____|     ',
                l3 = '|    T    |     ',
                l4 = '|...---"""\'     '
            }
            return ascii
        elseif string.lower(info.os):match("mac os") then
            local ascii = {
                l1 = RED .. '  __()_         ' .. NOCOL,
                l2 = YELLOW .. ".'     '.       " .. NOCOL,
                l3 = GREEN .. '|      (        ' .. NOCOL,
                l4 = CYAN .. "'._____.'       " .. NOCOL
            }
            return ascii
        elseif string.lower(info.os):match("android") then
            local ascii = {
                l1 = GREEN .. '  \\  _  /     ' .. NOCOL,
                l2 = GREEN .. ' .-"" ""-.    ' .. NOCOL,
                l3 = GREEN .. '/  O   O  \\   ' .. NOCOL,
                l4 = GREEN .. '|_________|   ' .. NOCOL
            }
            return ascii
        else -- AKA unknown
            randomness = math.random()
            if randomness >= 0 and randomness <= 0.25 then -- Orange Cat
                local ascii = {
                    l1 = B_RED .. "  /'._         " .. NOCOL,
                    l2 = B_RED .. " (" .. B_GREEN .. "° o" .. B_RED .. " 7        " .. NOCOL,
                    l3 = B_RED .. "  " ..YELLOW.. "|" .. B_RED .. "'-'".. YELLOW .."\"~.  .   " .. NOCOL,
                    l4 = B_RED .. "  Uu" .. YELLOW .. "^~" .. B_RED .. "C_J._.\"  " .. NOCOL
                }
                return ascii
            elseif randomness >= 0.25 and randomness <= 0.5 then -- Black Cat
                local ascii = {
                    l1 = BLACK .. "  /'._         " .. NOCOL,
                    l2 = BLACK .. " (" .. GREEN .. "° o" .. BLACK .. " 7        " .. NOCOL,
                    l3 = BLACK .. "  |'-'\"~.  .   " .. NOCOL,
                    l4 = BLACK .. "  Uu^~C_J._.\"  " .. NOCOL
                }
                return ascii
            elseif randomness >= 0.5 and randomness <= 0.75 then -- Calico Cat
                local ascii = {
                    l1 = B_RED .. "  /'." .. BLACK .. "_         " .. NOCOL,
                    l2 = " (" .. GREEN .. "° o" .. BLACK .. " 7        " .. NOCOL,
                    l3 = "  " .. BLACK .. "|".. WHITE .."'-'\"".. B_RED .."~.  .   " .. NOCOL,
                    l4 = "  " .. BLACK .. "U" .. WHITE .. "u^" .. B_RED .. "~C_J" .. WHITE .. "._.\"  " .. NOCOL
                }
                return ascii
            else -- if you get more than 0.75 you unlock my cat (his name is Sun and he's a tabby cat)
                local ascii = {
                    l1 = BLACK .. "  /'._         " .. NOCOL,
                    l2 = BLACK .. " (" .. YELLOW .. "° o " .. WHITE .. "7        " .. NOCOL,
                    l3 = GRAY .. "  |"..WHITE.."'-'".. GRAY .."\"".. BLACK .."~.  .   " .. NOCOL,
                    l4 = "  Uu^~C_J." .. YELLOW .. "_"..GRAY.."."..YELLOW.."\"  " .. NOCOL
                }
                return ascii
            end
        end


    else -- NO COLORS [Default]
        if string.lower(info.os):match("ubuntu") then
            local ascii = {
                l1 = "  /-'-( )       ",
                l2 = "( )    |        ",
                l3 = "  \\-.-( )       ",
                l4 = "                "
            }
            return ascii
        elseif string.lower(info.os):match("arch") then
            local ascii = {
                l1 = "   /\\           ",
                l2 = "  /\\ \\          ",
                l3 = " / .. \\         ",
                l4 = "/.'  '.\\        "
            }
            return ascii
        elseif string.lower(info.os):match("gentoo") then
            local ascii = {
                l1 = " ,--.           ",
                l2 = "( () \\          ",
                l3 = " `^  /          ",
                l4 = "  '~'           "
            }
            return ascii
        elseif string.lower(info.os):match("fedora") then
            local ascii = {
                l1 = "   /¯¯\\         ",
                l2 = " __|__          ",
                l3 = "/  T            ",
                l4 = "\\__/            "
            }
            return ascii
        elseif string.lower(info.os):match("debian") then
            local ascii = {
                l1 = "    _.._        ",
                l2 = "   (    |       ",
                l3 = "   | (_/        ",
                l4 = "    \\           "
            }
            return ascii
        elseif string.lower(info.os):match("alpine") then
            local ascii = {
                l1 = " /¯¯¯¯¯¯\\       ",
                l2 = "/  /\\/\\  \\      ",
                l3 = "\\ /  \\ \\ /      ",
                l4 = " \\______/       "
            }
            return ascii
        
        elseif string.lower(info.os):match("windows") then
            local ascii = {
                l1 = '|"""---....     ',
                l2 = '|____|____|     ',
                l3 = '|    T    |     ',
                l4 = '|...---"""\'     '
            }
            return ascii
        elseif string.lower(info.os):match("mac os") then
            local ascii = {
                l1 = '  __()_         ',
                l2 = ".'     '.       ",
                l3 = '|      (        ',
                l4 = "'._____.'       "
            }
            return ascii
        elseif string.lower(info.os):match("android") then
            local ascii = {
                l1 = '  \\  _  /     ',
                l2 = ' .-"" ""-.    ',
                l3 = '/  O   O  \\   ',
                l4 = '|_________|   '
            }
            return ascii
        else -- AKA unknown
            local ascii = {
                l1 = "  /'._         ",
                l2 = " (° o 7        ",
                l3 = "  |'-'\"~.  .   ",
                l4 = "  Uu^~C_J._.\"  "
            }
            return ascii
        end
    end
end

--[[ INITIALIZZATION ]]

if arg[1] == "--no-color" or arg[1] == "-n" then
    local info = fetch()
    art = ascii(info, false)

    io.write(art.l1 .. "os: " .. info.os .. "\n")
    io.write(art.l2 .. "wm: " .. info.wm .. "\n")
    io.write(art.l3 .. "kn: " .. info.kn .. "\n")
    io.write(art.l4 .. "sh: " .. info.sh .. "\n")
elseif arg[1] == "--help" or arg[1] == "-h" then
    io.write([[
        SWEF 1.0 - The Should-Work-Everywhere-Fetch
        -------------------------------------------
        usage: lua swef.lua [--help] [-h] [--no-color] [-n] [--no-ascii]
        --help, -h        Display this message
        --no-color, -n    Don't show the colors
    ]])
else
    local info = fetch()
    art = ascii(info, true)

    io.write(art.l1 .. B_RED    .. "os: " .. RED    .. info.os .. "\n")
    io.write(art.l2 .. B_YELLOW .. "wm: " .. YELLOW .. info.wm .. "\n")
    io.write(art.l3 .. B_GREEN  .. "kn: " .. GREEN  .. info.kn .. "\n")
    io.write(art.l4 .. B_CYAN   .. "sh: " .. CYAN   .. info.sh .. "\n")
end
