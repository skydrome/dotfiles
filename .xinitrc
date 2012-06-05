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

xrdb -merge ~/.Xresources
xset +fp /usr/share/fonts/local
xset fp rehash

DEFAULT_SESSION='startxfce4'
case $1 in
	xfce) exec ck-launch-session startxfce4 ;;
	#herbstluftwm) exec ck-launch-session i3 -V >>~/.i3/i3log >&1 ;;
	*) exec ck-launch-session $DEFAULT_SESSION ;;
esac

xmodmap ~/.Xmodmap
xinput set-int-prop "Synaptics Mouse" "Synaptics Two-Finger Pressure" 32 10
xinput set-int-prop "Synaptics Mouse" "Synaptics Two-Finger Width" 32 6
xinput set-int-prop "Synaptics Mouse" "Two-Finger Scrolling" 4 1
xinput set-int-prop "Synaptics Mouse" "Synaptics Two-Finger Scrolling" 4 1 1
xinput set-int-prop "Synaptics Mouse" "Synaptics Jumpy Cursor Threshold" 32 150
