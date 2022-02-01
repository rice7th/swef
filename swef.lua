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
                kn = "minix or bsd??",
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
            os = "NANI?!?",
            wm = "not sure",
            kn = "unknown",
            sh = "unknown"
        }
        return fetch
    end
end
--[[ INITIALIZZATION ]]
local info = fetch()

function ascii()
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
            l1 = '  __()_      ',
            l2 = ".'     '.    ",
            l3 = '|      (     ',
            l4 = "'._____.'    "
        }
        return ascii
    elseif string.lower(info.os):match("android") then
        local ascii = {
            l1 = '  \\  ___  /     ',
            l2 = ' .-""   ""-.    ',
            l3 = '/  O     O  \\   ',
            l4 = '|___________|   '
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
-- info.os = "debian"
art = ascii()

io.write(art.l1 .. "os: " .. info.os .. "\n")
io.write(art.l2 .. "wm: " .. info.wm .. "\n")
io.write(art.l3 .. "kn: " .. info.kn .. "\n")
io.write(art.l4 .. "sh: " .. info.sh .. "\n")
