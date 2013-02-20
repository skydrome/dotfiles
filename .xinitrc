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

export GTK2_RC_FILES="/etc/gtk-2.0/gtkrc:$HOME/.gtkrc-2.0"

launch() {
    exec $*
}

case ${2:-openbox} in
    openbox) launch openbox-session ;;
    *      ) launch $2 #echo >&2 "Unrecognized command $2"; exit 1 ;;
esac
