clear
cat <<"EOF"
        [1;34m/[1;34m#[1;34m\[1;34m                      _    [0;34m _ _
       [1;34m/[1;34m###[1;34m\[1;34m       __ _ _ __ ___| |__ [0;34m| (_)_ __  _   ___  __
      [1;34m/[1;34m#####[1;34m\[1;34m     / _` | '__/ __| '_ \[0;34m| | | '_ \| | | \ \/ /
     [1;34m/##[0;34m,-,##[0;34m\[1;34m   | (_| | | | (__| | | |[0;34m | | | | | |_| |>  <
    [0;34m/[0;34m##(   )##[0;34m\[1;34m   \__,_|_|  \___|_| |_|[0;34m_|_|_| |_|\__,_/_/\_\
   [0;34m/[0;34m#.--   --.#[0;34m\[0;38m   A simple, elegant GNU/Linux distribution.
  [0;34m/[0;34m`           `[0;34m\[0m
EOF

# modules
autoload -U  compinit   && compinit
autoload -U  promptinit && promptinit
autoload -U  colors     && colors
autoload -U url-quote-magic
zle -N self-insert url-quote-magic
zmodload zsh/complist

READNULLCMD=$MANPAGER
HISTFILE=$HOME/.zhistory
HISTSIZE=5000
SAVEHIST=10000
DIRSTACKSIZE=20

setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
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
BROWSER="chromium"  \
EDITOR='nano'       \
VISUAL=$EDITOR      \
LANG="en_US.UTF-8"  \
LC_CTYPE="en_US.UTF-8" \
PAGER='less'        \
LESSHISTFILE=-      \
LESS=-R             \
GREP_COLOR="4;1;31" \
GREP_OPTIONS='--color=auto'     \
LESS_TERMCAP_mb=$'\E[01;31m'    \
LESS_TERMCAP_md=$'\E[01;31m'    \
LESS_TERMCAP_me=$'\E[0m'        \
LESS_TERMCAP_se=$'\E[0m'        \
LESS_TERMCAP_so=$'\E[00;47;30m' \
LESS_TERMCAP_ue=$'\E[0m'        \
LESS_TERMCAP_us=$'\E[01;32m'    \

foreach f in ~/.z{prompt,style,bindkeys,functions,private}; {
    source $f
}

#export CC=gcc CXX=g++
export CC=clang CXX=clang++

CFLAGS="-march=native -O3 -pipe -fstack-protector -D_FORTIFY_SOURCE=2"
CFLAGS+=" -mfpmath=sse -fPIE -fuse-linker-plugin"
CFLAGS+=" -Wformat-security -fPIE"

export CFLAGS CXXFLAGS="-std=gnu++11 $CFLAGS"
export LDFLAGS="-Wl,-O1,--sort-common,--as-needed,-z,relro" # -pie"
export MAKEFLAGS="-j2"
