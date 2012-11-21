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

eval $(locale)
umask 077

export GTK2_RC_FILES="/etc/gtk-2.0/gtkrc:$HOME/.gtkrc-2.0"
export PATH="$HOME/bin:$PATH"

xrdb -merge ~/.Xresources &

#setkeycodes e025 130
#setkeycodes e026 131
#setkeycodes e027 132
#setkeycodes e029 122
#setkeycodes e071 134
#setkeycodes e072 135

xmodmap ~/.Xmodmap &
ssh_forward &
urxvtd -q -o -f &

launch() {
    exec dbus-launch --binary-syntax --close-stderr --exit-with-session $*
}

case ${2:-openbox} in
    openbox) launch openbox-session ;;
    *      ) launch $2 #echo >&2 "Unrecognized command $2"; exit 1 ;;
esac
