cat <<"EOF"
         [1;34m.
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

function +vi-git-status {
    if [[ -n $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
        hook_com[unstaged]='%F{red}●%f'
    fi
}

function prompt_precmd {
    [[ -d ".git" ]] &&
        vcs_info || unset vcs_info_msg_0_
}

function init_prompt {
    local uc hc pc dc
    [[ -n $SSH_TTY ]] &&
    hc=yellow || hc=blue
    uc=${1:+%F{$1}}
    hc=${2:-$hc}
    pc=${3:-'g'}
    dc=${4:-'o'}

    setopt LOCAL_OPTIONS
    unsetopt XTRACE KSH_ARRAYS
    prompt_opts=(cr percent subst)

    autoload -Uz add-zsh-hook
    autoload -Uz vcs_info

    add-zsh-hook precmd prompt_precmd

    zstyle ':vcs_info:*' enable git
    zstyle ':vcs_info:*' 'check-for-changes' true
    zstyle ':vcs_info:*' stagedstr '%F{g}●%f'
    zstyle ':vcs_info:*' unstagedstr '%F{y}●%f'
    zstyle ':vcs_info:*' formats '%F{g}%b%c%u%F{n}'
    zstyle ':vcs_info:*' actionformats "%b%c%u|%F{c}%a%f"
    zstyle ':vcs_info:git*+set-message:*' hooks git-status

    PROMPT='
╭─${batt}${temp}°─☾'${uc:-'%(#.%F{red}.%F{cyan})'}"%n%F{$dc}@%F{$hc%}%m%F{$dc}☽ %F{$pc}%0~%F{r}%(?..  ↵%?) %F{$dc}
╰──▶ "
    RPROMPT='${vcs_info_msg_0_}%F{n}'
    SPROMPT='zsh: correct %F{r}%R%f to %F{g}%r%f [nyae]? '
    PROMPT2=' ─▶ '
}

case "$TERM" in
    vte*|xterm*|rxvt*)
        function precmd {
            print -Pn '\e];Terminal: [%m] %n (%~)\a'
            temp=$(cat /sys/class/thermal/thermal_zone0/temp | cut -c1-2)
            bat_now=$(cat /sys/class/power_supply/BAT1/charge_now)
            #bat_full=$(cat /sys/class/power_supply/BAT1/charge_full)
            bat_full=6332000
            (( bat_now != bat_full )) &&
              batt="$(( bat_now*100 / bat_full ))%%─" || batt=
        }
    ;;
esac
eval $(dircolors -b)

init_prompt

foreach f in ~/.z{style,functions,private}; {
    source $f
}
source /usr/share/doc/pkgfile/command-not-found.zsh

CC=clang
CXX=clang++
#CC=gcc
#CXX=g++
CFLAGS="-Os -pipe -march=native"
CFLAGS+=" -flto"
CFLAGS+=" -fstack-protector -D_FORTIFY_SOURCE=2" # --param=ssp-buffer-size=4"
LDFLAGS="-Wl,-O1,--sort-common,--as-needed,-z,relro"
export MAKEFLAGS="-j2" CFLAGS CXXFLAGS="${CFLAGS}" LDFLAGS CC CXX
