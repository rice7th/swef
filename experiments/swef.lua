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

function onlymatch(s, p) -- grab only the match of the pattern
    return string.sub(s, string.find(s, p))
end


function opencmd(cmd)
    local command = io.popen(cmd, "r")
    local command_output = command:read("*a")
    command:close()
    command_output = onlymatch(command_output, "%C+")
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
            wm = opencmd('ps -e | grep -m 1 -oi "arcan\\|asc\\|clayland\\|dwc\\|fireplace\\|gnome-shell\\|greenfield\\|grefsen\\|hikari\\|kwin\\|lipstick\\|maynard\\|mazecompositor\\|motorcar\\|orbital\\|orbment\\|perceptia\\|river\\|rustland\\|sway\\|ulubis\\|velox\\|wavy\\|way-cooler\\|wayfire\\|wayhouse\\|westeros\\|westford\\|weston\\|gnome"')
            if wm == "gnome" then
                return "mutter"
            else
                return wm
            end
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
    return opencmd([[ps -e | grep -o \
    -e "[S]pectacle" \
    -e "[A]methyst" \
    -e "[k]wm" \
    -e "[c]hun[k]wm" \
    -e "[y]abai" \
    -e "[R]ectangle"]])
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
        else
            local fetch = {
                os = "Maybe BSD or Minix, this is still in WIP",
                wm = "¯\\_(ツ)_/¯",
                kn = "minix or bsd??",
                sh = "¯\\_(ツ)_/¯"
            }
            return fetch
        end
    elseif os_type == "windows" then
        local fetch = {
            os = "windows [WIP]",
            wm = "explorer",
            kn = "DOS",
            sh = "cmd.exe"
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

info = fetch()
io.write("os: " .. info.os .. "\n")
io.write("wm: " .. info.wm .. "\n")
io.write("kn: " .. info.kn .. "\n")
io.write("sh: " .. info.sh .. "\n")
