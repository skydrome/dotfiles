(( UID == 0 )) && isroot=true || isroot=false
have() { which $1 &>/dev/null || return 1 }

# modules
autoload -U compinit promptinit
compinit
promptinit
zmodload zsh/complist

# smart urls
autoload -U url-quote-magic
zle -N self-insert url-quote-magic

# input with no command
READNULLCMD=$MANPAGER
# history
HISTFILE=$HOME/.zhistory
HISTSIZE=5000
SAVEHIST=10000
DIRSTACKSIZE=20

setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.

setopt \
  always_to_end \
  append_history \
  auto_cd \
  auto_menu \
  auto_name_dirs \
  auto_param_keys \
  auto_param_slash \
  auto_pushd \
  auto_remove_slash \
  bang_hist \
  bg_nice \
  brace_ccl \
  cdable_vars \
  chase_links \
  complete_aliases \
  complete_in_word \
  correct \
  extended_glob \
  extended_history \
  hist_ignore_space \
  hist_verify \
  inc_append_history \
  interactive_comments \
  list_ambiguous \
  list_packed \
  long_list_jobs \
  multios \
  prompt_subst \
  pushd_ignore_dups \
  pushd_silent \
  pushd_to_home \
  rc_quotes \
  share_history \
  short_loops \
  notify \
  nobgnice \
  printexitvalue \
  histappend \
  histreduceblanks \
  dotglob \
  numericglobsort \
  nolisttypes \

case "$TERM" in
    vte*|xterm*|rxvt*)
        function precmd {
            print -Pn '\e];Terminal: [%m] %n (%~)\a'
        }
        function preexec {
            local cmd=${1[(wr)^(*=*|sudo|ssh|-*)]}
            print -Pn "\e];$cmd:q\a"
        }
    ;;
esac
eval $(dircolors -b ~/.dir_colors)

export \
BROWSER="chromium" \
EDITOR='nano' \
VISUAL='nano' \
PAGER='less' \
LESSHISTFILE=- \
LESS=-R        \
GREP_COLOR="4;1;31" \
GREP_OPTIONS='--color=auto' \
LESS_TERMCAP_mb=$'\E[01;31m'    \
LESS_TERMCAP_md=$'\E[01;31m'    \
LESS_TERMCAP_me=$'\E[0m'        \
LESS_TERMCAP_se=$'\E[0m'        \
LESS_TERMCAP_so=$'\E[00;47;30m' \
LESS_TERMCAP_ue=$'\E[0m'        \
LESS_TERMCAP_us=$'\E[01;32m'    \

#export CC=gcc CXX=g++
export \
CC=clang \
CXX=clang++ \
CFLAGS="-march=native -O3 -pipe -fstack-protector -D_FORTIFY_SOURCE=2" \
#CFLAGS="CFLAGS -mfpmath=sse -fuse-linker-plugin" \
CXXFLAGS="-std=gnu++11 $CFLAGS" \
LDFLAGS="-Wl,-O1,--sort-common,--as-needed,-z,relro" \
MAKEFLAGS="-j2"


cat <<"EOF"
       [1;34m/[1;34m#[1;34m\[0;34m                      _     _ _
      [1;34m/[1;34m###[1;34m\[0;34m       __ _ _ __ ___| |__ | (_)_ __  _   ___  __
     [1;34m/[1;34m#####[1;34m\[0;34m     / _` | '__/ __| '_ \| | | '_ \| | | \ \/ /
    [1;34m/##[0;34m,-,##[0;34m\[0;34m   | (_| | | | (__| | | | | | | | | |_| |>  <
   [0;34m/[0;34m##(   )##[0;34m\[0;34m   \__,_|_|  \___|_| |_|_|_|_| |_|\__,_/_/\_\
  [0;34m/[0;34m#.--   --.#[0;34m\[0;38m   A simple, elegant GNU/Linux distribution.
 [0;34m/[0;34m`           `[0;34m\[0m
EOF

foreach f in ~/.z{bindkeys,functions,style,prompt,private}; {
    source $f
}
