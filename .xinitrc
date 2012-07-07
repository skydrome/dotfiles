#!/bin/sh
#
# ~/.xinitrc
#

xset +fp /usr/share/fonts/local
xset fp rehash &
xrdb -merge ~/.Xresources &

xmodmap ~/.Xmodmap &
xinput set-int-prop "Synaptics Mouse" "Synaptics Two-Finger Pressure" 32 10
xinput set-int-prop "Synaptics Mouse" "Synaptics Two-Finger Width" 32 6
xinput set-int-prop "Synaptics Mouse" "Two-Finger Scrolling" 4 1
xinput set-int-prop "Synaptics Mouse" "Synaptics Two-Finger Scrolling" 4 1 1
xinput set-int-prop "Synaptics Mouse" "Synaptics Jumpy Cursor Threshold" 32 150

launch() {
  exec ck-launch-session dbus-launch $*
}

case ${2:-xfce4} in
    xfce4) launch startxfce4 --with-ck-launch ;;
    *    ) echo >&2 "Unrecognized command $2"; exit 1 ;;
esac

