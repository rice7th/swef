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

local RED    = "\x1b[31m"
local GREEN  = "\x1b[32m"
local YELLOW = "\x1b[33m"
local BLUE   = "\x1b[34m"
local PURPLE = "\x1b[35m"
local CYAN   = "\x1b[36m"

local B_RED    = "\x1b[91m"
local B_GREEN  = "\x1b[92m"
local B_YELLOW = "\x1b[93m"
local B_BLUE   = "\x1b[94m"
local B_PURPLE = "\x1b[95m"
local B_CYAN   = "\x1b[96m"


-- Monochromatic
local BLACK  = "\x1b[30m"
local GRAY   = "\x1b[90m"
local B_GRAY  = "\x1b[37m"
local WHITE   = "\x1b[97m"

-- Remove all colors
local NOCOL = "\x1b[0m"

--[[ STOLEN FROM:: https://stackoverflow.com/a/40195356]]
-- Checks if a file exist
local function exists(file)
    local ok, err, code = os.rename(file, file)
    return ok or code == 13, err
end

local function isdir(path)
    return exists(path.."/")
end



local function opencmd(cmd)
    local command = io.popen(cmd, "r")
    local command_output = command:read("*a")
    command:close()
    command_output = command_output:match("%C+")
    return command_output
end


local function os_family()
    local os_family = package.config:sub(1,1)
    if os_family == "/" then
        return "unix"
    elseif os_family == "\\" then
        return "windows"
    end
end

local function shell()
    -- local does_proc_exist = isdir("/proc")
    --if does_proc_exist then
    --    return opencmd("cat /proc/$$/comm")
    --else
        return opencmd("basename $SHELL")
    --end
end

local function linux_wm()
    local graphic_session = os.getenv("XDG_SESSION_TYPE")
    if graphic_session then
        if graphic_session:lower() == "x11" then
            return opencmd([[xprop -id "$(xprop -root _NET_SUPPORTING_WM_CHECK | cut -d' ' -f5)" _NET_WM_NAME | cut -d'"' -f2]])
        elseif graphic_session:lower() == "wayland" then
            local wm_pid_command = io.popen("ps -e")
            local wm_pids = wm_pid_command:read("*a"):lower()
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
            for i=1,#wayland_wm_list do
                if wm_pids:find(wayland_wm_list[i]) then
                    wm = wayland_wm_list[i]
                    break
                end
            end
            if wm == "gnome-shell" then
                return "mutter"
            else
                return wm or os.getenv("WAYLAND_DISPLAY") or error(":v")
            end
        else
            return "unknown"
        end
    else
        -- Graphic session is TTY
        return "tty"
    end
end


local function macos_wm()
    local wm_pid_command = io.popen("ps -e")
    local wm_pids = wm_pid_command:read("*a"):lower()
    wm_pid_command:close()
    local macos_wm_list = {
        "spectacle",
        "amethyst",
        "kwm",
        "chunkwm",
        "yabai",
        "rectangle"
    }
    for i=1,#macos_wm_list do
        if wm_pids:find(macos_wm_list[i]) then
            wm = macos_wm_list[i]
            break
        end
    end
    return wm or "Quartz Compositor" or error("WTF")
end

local function windows_wm()
    local wm_pid_command = io.popen("tasklist")
    local wm_pids = wm_pid_command:read("*a"):lower()
    wm_pid_command:close()
    local windows_wm_list = {
        "bugn",
        "windawesome",
        "blackbox",
        "emerge",
        "litestep",
        "explorer"
    }
    for i=1,#windows_wm_list do
        if wm_pids:find(windows_wm_list[i]) then
            wm = windows_wm_list[i]
            break
        end
    end
    return wm or error("HOW")
end

local function windows_version()
    local windows_ver = opencmd("wmic os get Caption /value")
    windows_ver = windows_ver:gsub("Caption=", '')
    return windows_ver
end

local function distro()
    local distro_command = io.open("/etc/os-release", "r")
    local distro_temp = distro_command:read("*a")
    distro_command:close()
    local distro = distro_temp:match("NAME.%W?%w+", 1):gsub('"', ''):gsub('NAME=', '')
    return distro
end

local function fetch()
    local os_type = os_family()
    if os_type == "unix" then
        -- Get Kernel name
        kern = opencmd("uname")

        -- Get Kernel release
        kern_release = opencmd("uname -r")

        -- Get OS Name (not distro!)
        os_name = opencmd("uname -o")
        -- Check if the kernel is linux, macos, bsd or other
        if kern:lower() == "linux" then
            if os_name:lower() == "android" then
                local fetch = {
                    os = "Android",
                    wm = "AndroidWM",
                    kn = kern .. kern_release,
                    sh = shell()
                }
                return fetch

            elseif os_name:lower() == "gnu/linux" or "linux" then
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
        elseif kern:lower() == "darwin" then
            local fetch = {
                os = "Mac Os",
                wm = macos_wm(),
                kn = kern .. " " .. kern_release,
                sh = shell()
            }
            return fetch
        elseif kern:lower():find("mingw64") then
            local fetch = {
                os = "Windows (mingw)",
                wm = windows_wm(),
                kn = "mingw64",
                sh = shell()
            }
            return fetch
        elseif kern:lower():find("BSD") then
            local fetch = {
                os = os_name,
                wm = "WIP",
                kn = kern .. kern_release,
                sh = opencmd("basename $SHELL")
            }
            return fetch
        else
            local fetch = {
                os = "Maybe or Minix, this is still in WIP",
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




local function ascii(info)
    if string.lower(info.os):find("ubuntu") then
        local ascii = {
            l1 = YELLOW .. "  /-".. B_RED .."'-" .. RED .. "( )       " .. NOCOL,
            l2 = B_RED .. "( )    |        " .. NOCOL,
            l3 = YELLOW .. "  \\-".. RED ..".-".. YELLOW .."( )       " .. NOCOL,
            l4 = NOCOL .. "                " .. NOCOL
        }
        --   /-'-( )       
        -- ( )    |        
        --   \-.-( )       
        --
        return ascii
    elseif string.lower(info.os):find("arch") then
        local ascii = {
            l1 = CYAN .. "   /\\           " .. NOCOL,
            l2 = CYAN .. "  /\\ \\          " .. NOCOL,
            l3 = CYAN .. " / .. \\         " .. NOCOL,
            l4 = CYAN .. "/.'  '.\\        " .. NOCOL
        }
        --    /\     
        --   /  \  
        --  / .. \ 
        -- /.'  '.\
        return ascii
    elseif string.lower(info.os):find("gentoo") then
        local ascii = {
            l1 = B_GRAY .. " ,--.           " .. NOCOL,
            l2 = B_GRAY .. "( () \\          " .. NOCOL,
            l3 = B_GRAY .. " `^  /          " .. NOCOL,
            l4 = B_GRAY .. "  '~'           " .. NOCOL
        }
        --  ,--.           
        -- ( () \          
        --  `^  /          
        --   '~'           
        return ascii
    elseif string.lower(info.os):find("fedora") then
        local ascii = {
            l1 = BLUE .. "   /¯¯\\         " .. NOCOL,
            l2 = BLUE .. " __|__          " .. NOCOL,
            l3 = BLUE .. "/  T            " .. NOCOL,
            l4 = BLUE .. "\\__/            " .. NOCOL
        }
        --    /¯¯\        
        --  __|__          
        -- /  T            
        -- \__/           
        return ascii
    elseif string.lower(info.os):find("debian") then
        local ascii = {
            l1 = RED .. "  _.._        " .. NOCOL,
            l2 = RED .. " (    |       " .. NOCOL,
            l3 = RED .. " | (_/        " .. NOCOL,
            l4 = RED .. "  \\           " .. NOCOL
        }
        --  _.._        
        -- (    |       
        -- | (_/        
        --  \          
        return ascii
    elseif string.lower(info.os):find("alpine") then
        local ascii = {
            l1 = BLUE .. " /¯¯¯¯¯¯\\       " .. NOCOL,
            l2 = BLUE .. "/  " .. WHITE .. "/\\/\\" .. BLUE .. "  \\      " .. NOCOL,
            l3 = BLUE .. "\\ " .. WHITE .. "/  \\ \\" .. BLUE .. " /      " .. NOCOL,
            l4 = BLUE .. " \\______/       " .. NOCOL
        }
        --  /¯¯¯¯¯¯\
        -- /  /\/\  \      
        -- \ /  \ \ /
        --  \______/
        return ascii
    elseif string.lower(info.os):find("void") then
        local ascii = {
            l1 = BLUE .. " /¯¯¯¯¯¯\\       " .. NOCOL,
            l2 = BLUE .. "/  " .. WHITE .. "/\\/\\" .. BLUE .. "  \\      " .. NOCOL,
            l3 = BLUE .. "\\ " .. WHITE .. "/  \\ \\" .. BLUE .. " /      " .. NOCOL,
            l4 = BLUE .. " \\______/       " .. NOCOL
        }
        --   .''-.
        --/'.  '. \
        --\ '.  './
        -- '-..'
        return ascii
    
    elseif string.lower(info.os):find("windows") then
        local ascii = {
            l1 = CYAN .. '|"""---....     ' .. NOCOL,
            l2 = CYAN .. '|____|____|     ' .. NOCOL,
            l3 = CYAN .. '|    T    |     ' .. NOCOL,
            l4 = CYAN .. '|...---"""\'     ' .. NOCOL
        }
        --|"""---....     
        --|____|____|     
        --|    T    |     
        --|...---"""''    
        return ascii
    elseif string.lower(info.os):find("mac os") then
        local ascii = {
            l1 = RED .. '  __()_         ' .. NOCOL,
            l2 = YELLOW .. ".'     '.       " .. NOCOL,
            l3 = GREEN .. '|      (        ' .. NOCOL,
            l4 = CYAN .. "'._____.'       " .. NOCOL
        }
        --   __()_        
        -- .'     '.      
        -- |      (       
        -- '._____.'      
        return ascii
    elseif string.lower(info.os):find("android") then
        local ascii = {
            l1 = GREEN .. '  \\  _  /     ' .. NOCOL,
            l2 = GREEN .. ' .-"" ""-.    ' .. NOCOL,
            l3 = GREEN .. '/  O   O  \\   ' .. NOCOL,
            l4 = GREEN .. '|_________|   ' .. NOCOL
        }
        --   \  _  /    
        --  .-"" ""-.    
        -- /  O   O  \
        -- |_________|   
        return ascii
    else -- AKA unknown
        math.randomseed(os.time())
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
        -- GET DA KITTY!
        --  /'._         
        -- (° o 7        
        --  |'-'"~.  .  
        --  Uu^~C_J._." 
    end
    
end

--[[ INITIALIZZATION ]]

if arg[1] == "--icons" or arg[1] == "-i" then
    local info = fetch()
    art = ascii(info)

    io.write(art.l1 .. RED    .. "\u{f05a}  " .. NOCOL .. info.os .. "\n")
    io.write(art.l2 .. YELLOW .. "\u{f2d0}  " .. NOCOL .. info.wm .. "\n")
    io.write(art.l3 .. GREEN  .. "\u{f085}  " .. NOCOL .. info.kn .. "\n")
    io.write(art.l4 .. CYAN   .. "\u{e795}  " .. NOCOL .. info.sh .. "\n")
elseif arg[1] == "--help" or arg[1] == "-h" then
    io.write([[
SWEF 1.0 - The Should-Work-Everywhere-Fetch
-------------------------------------------
usage: lua swef.lua [--help] [-h] [--no-color] [-n] [--no-ascii]
--help, -h        Display this message
--icons, -i       Use nerd fonts
    ]])
else
    local info = fetch()
    art = ascii(info)

    io.write(art.l1 .. RED    .. "os: " .. NOCOL .. info.os .. "\n")
    io.write(art.l2 .. YELLOW .. "wm: " .. NOCOL .. info.wm .. "\n")
    io.write(art.l3 .. GREEN  .. "kn: " .. NOCOL .. info.kn .. "\n")
    io.write(art.l4 .. CYAN   .. "sh: " .. NOCOL .. info.sh .. "\n")
end
