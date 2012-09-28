#!/bin/sh
#
# ~/.xinitrc
#

eval $(locale)
umask 077

export GTK2_RC_FILES="/etc/gtk-2.0/gtkrc:$HOME/.gtkrc-2.0"
export PATH="$HOME/bin:${PATH}"
export MALLOC_CHECK_=1

xrdb -merge ~/.Xresources &

setkeycodes e025 130
setkeycodes e026 131
setkeycodes e027 132
setkeycodes e029 122
setkeycodes e071 134
setkeycodes e072 135

xmodmap ~/.Xmodmap &
xinput set-int-prop "Synaptics Mouse" "Synaptics Two-Finger Pressure" 32 10
xinput set-int-prop "Synaptics Mouse" "Synaptics Two-Finger Width" 32 6
xinput set-int-prop "Synaptics Mouse" "Two-Finger Scrolling" 4 1
xinput set-int-prop "Synaptics Mouse" "Synaptics Two-Finger Scrolling" 4 1 1
xinput set-int-prop "Synaptics Mouse" "Synaptics Jumpy Cursor Threshold" 32 150

urxvtd -q -o -f

launch() {
    exec dbus-launch --binary-syntax --close-stderr --exit-with-session $*
}

case ${2:-openbox} in
    openbox) launch openbox-session ;;
    e17    ) launch enlightenment_start ;;
    *      ) launch $2 #echo >&2 "Unrecognized command $2"; exit 1 ;;
esac
