#!/bin/sh
#
# ~/.xinitrc
#

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

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
  exec ck-launch-session $*
}

case ${2:-xfce4} in
    xfce4)
        launch startxfce4 --with-ck-launch
        rxvtd -q -o -f &
        ;;
    *)
        echo >&2 "Unrecognized command $2"; exit 1
esac

