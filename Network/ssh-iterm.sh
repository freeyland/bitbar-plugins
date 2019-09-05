#!/usr/bin/env bash
#
# Easily start/stop a background SSH forwarding connection
# The list of hosts are extracted from ~/.ssh/config by default
#
# To connect to your favorit host, just click the host name
# To disconnect the host, click the host name that is displayed as "(connecting)"
#
# <bitbar.title>SSH Tunnel</bitbar.title>
# <bitbar.version>v1.0</bitbar.version>
# <bitbar.author>mutsune</bitbar.author>
# <bitbar.author.github>mutsune</bitbar.author.github>
# <bitbar.desc>Easily start/stop a background SSH forwarding connection.</bitbar.desc>
# <bitbar.image>https://raw.githubusercontent.com/wiki/mutsune/bitbar-plugins/images/ssh-tunnel.png</bitbar.image>
#


if [[ "$2" = "sshconnect" ]]; then
osascript - "ssh $1" <<EOF
on run argv
tell application "iTerm"
    activate
    set new_term to (create window with default profile)
    tell new_term
        tell the current session
            repeat with arg in argv
               write text arg
            end repeat
        end tell
    end tell
end tell
end run
EOF
	exit
fi


echo " SSH|"
echo "---"

# get host names that are specified forwarding options
function hosts() {
    awk '
        $1 == "Host" {
            host = $2;
            next;
        }
        $1 == "HostName" {
            print host;
        }
    ' "$1"
}

for h in $(hosts ~/.ssh/config); do
    A="$(cut -d'/' -f2 <<<"${h}")"
    B="$(cut -d'/' -f1 <<<"${h}")"
    C="$(cut -d'/' -f3 <<<"${h}")"
    if [[ "$C" != "" ]]; then
        if [[ "$B" != "$prevB" ]]; then
            echo "$B"
        fi
        if [[ "$A" != "$prevA" ]]; then
            echo "-- $A"
        fi
        echo "---- $C | bash='$0' param1=${h} param2='sshconnect' terminal=false refresh=true"
        prevA=$A
        prevB=$B
    else
        if [[ "$B" != "$prevB" ]]; then
            echo "$B"
        fi
        echo "-- $A | bash='$0' param1=${h} param2='sshconnect' terminal=false refresh=true"
        prevA=$A
        prevB=$B
    fi
done



