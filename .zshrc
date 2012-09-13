(( UID == 0 )) && isroot=true || isroot=false
have() { which $1 &>/dev/null || return 1 }

# modules
autoload -U compinit \
    edit-command-line \
    zmv \
    colors
compinit
colors
zle -N edit-command-line
zmodload zsh/complist

# smart urls
autoload -U url-quote-magic
zle -N self-insert url-quote-magic

# shell options
setopt nobeep \
    notify \
    nobgnice \
    correct \
    interactivecomments \
    printexitvalue \
    autocd \
    autopushd \
    pushdtohome \
    chaselinks \
    histverify \
    histappend \
    sharehistory \
    histreduceblanks \
    histignorespace \
    histignorealldups \
    histsavenodups \
    braceccl \
    dotglob \
    extendedglob \
    numericglobsort \
    nolisttypes \
    promptsubst \
    completealiases

# input with no command
READNULLCMD=$MANPAGER
# history
HISTFILE=$HOME/.zhistory
HISTSIZE=5000
SAVEHIST=10000
DIRSTACKSIZE=20

setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.
setopt HIST_VERIFY               # Do not execute immediately upon history expansion.

# logout of root shell after 180 seconds
$isroot && TMOUT=180

# completion style
# menu completion
zstyle ':completion:*' menu select
# colors for file completion
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# complete all processes
zstyle ':completion:*:processes' command 'ps -e'
zstyle ':completion:*:processes-names' command 'ps -eo comm'
# cache completion
zstyle ':completion:*' use-cache on
# don't complete working directory in parent
zstyle ':completion:*' ignore-parents parent pwd
# completion for pacman-color
compdef _pacman pacman-color=pacman

# prompt
autoload -Uz promptinit && promptinit
# initialize vimode (stops linux console glitch)
vimode=i
# set vimode to current editing mode
function zle-line-init zle-keymap-select {
    vimode="${${KEYMAP/vicmd/c}/(main|viins)/i}"
    zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

# ➤  ↵  »  ✔  ✗  ➜  ✚  ✹  ✖  ═  ✭  ⚡  ➭  ❮
# ▍ ♩ & ♫  ♪ ♬  ♭ ♮ ♯ ☺  ☻ ::  ⏎
# ♥  ♦ ♣  ♠  • ◘ ○ ◙  ♂ ♀
# ☭  , ⌘  , ☠, ⌥  , ✇ , ⌤  ,
# ⍜ , ✣ , ⌨   , ⌘, ☕
# ☮ ☠ ☻ ❀ ☃ ☆ ☄  ☢ ☉ ◎ ⊙ ░ ⍟
# ￬ ￪ ￫ ￩ ⇧ ⇩ ⇨ ⇦ ↑ ↓ ≠ ∞ ⿻  □  "
# ☼ ► ◄  ↕

_color=(
    "%F{cyan}"
    "%F{yellow}"
    "%F{magenta}"
    "%F{red}"
    "%F{green}"
)
return_code='%(?..${_color[4]}%? ↵%f)'
PROMPT="╭─${_color[3]}%n%f@${_color[2]}%m%f:${_color[1]}%~%f
╰─▶ "
RPROMPT="${return_code}"

# aliases
have pacman-color && alias pacman=pacman-color
have colordiff && alias diff=colordiff
alias ls='ls -Ah --group-directories-first --color=auto'
alias df='df -h'
alias du='du -h'
alias free='free -m'
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -Iv'
alias ln='ln -iv'
alias install='install -v'
alias mount='mount -v'
alias umount='umount -v'
alias chown='chown -c --preserve-root'
alias chmod='chmod -c --preserve-root'
alias chgrp='chgrp -c --preserve-root'
alias rmdir='rmdir -v'
alias mkdir='mkdir -vp'
alias p=pacman
alias ll='ls -l'
alias rr='rm -r'
alias dirs='dirs -p'

if ! $isroot; then
    alias sudo="sudo "
    # general
    [[ -n $DISPLAY ]] || alias mplayer='mplayer -vo fbdev'
    alias ncmpc=ncmpcpp
    # sudo apps
    for app in \
        powertop nmap pacman iptables arptables pwck grpck updatedb reboot halt shutdown
    do
        alias $app="sudo $app"
    done
    # sudo guis
    alias gparted='sudo -b gparted &>/dev/null'
    alias zenmap='sudo -b zenmap &>/dev/null'
else
    # root guis
    alias gparted='gparted &>/dev/null &'
    alias zenmap='zenmap &>/dev/null &'
fi

# functions
# bg on empty line, push-input on non-empty line
fancy-ctrl-z () {
    if [[ $#BUFFER -eq 0 ]]; then
        bg
        zle redisplay
    else
        zle push-input
    fi
}
zle -N fancy-ctrl-z

# up-line-or-search with more than the first word
up-line-or-history-beginning-search-backward () {
    if [[ -n $PREBUFFER ]]; then
        zle up-line-or-history
    else
        zle history-beginning-search-backward
    fi
}
zle -N up-line-or-history-beginning-search-backward

# down-line-or-search with more than the first word
down-line-or-history-beginning-search-forward () {
    if [[ -n $PREBUFFER ]]; then
        zle down-line-or-history
    else
        zle history-beginning-search-forward
    fi
}
zle -N down-line-or-history-beginning-search-forward

# make zsh/terminfo work for terms with application and cursor modes
case "$TERM" in
    vte*|xterm*)
        zle-line-init() { zle-keymap-select; echoti smkx }
        zle-line-finish() { echoti rmkx }
        zle -N zle-line-init
        zle -N zle-line-finish
        ;;
esac

# do history expansion on space
bindkey              ' '                magic-space

# page up (and <C-b> in vicmd)
if [[ -n $terminfo[kpp] ]]; then
    bindkey          "$terminfo[kpp]"   beginning-of-buffer-or-history
    bindkey -M vicmd "$terminfo[kpp]"   beginning-of-buffer-or-history
fi
bindkey -M vicmd     '^B'               beginning-of-buffer-or-history
# page down (and <C-f> in vicmd)
if [[ -n $terminfo[knp] ]]; then
    bindkey          "$terminfo[knp]"   end-of-buffer-or-history
    bindkey -M vicmd "$terminfo[knp]"   end-of-buffer-or-history
fi
bindkey -M vicmd     '^F'               end-of-buffer-or-history
# up arrow (history search)
if [[ -n $terminfo[kcuu1] ]]; then
    bindkey          "$terminfo[kcuu1]" up-line-or-history-beginning-search-backward
    bindkey -M vicmd "$terminfo[kcuu1]" up-line-or-history-beginning-search-backward
fi
# down arrow (history search)
if [[ -n $terminfo[kcud1] ]]; then
    bindkey          "$terminfo[kcud1]" down-line-or-history-beginning-search-forward
    bindkey -M vicmd "$terminfo[kcud1]" down-line-or-history-beginning-search-forward
fi
# left arrow (whichwrap)
if [[ -n $terminfo[kcub1] ]]; then
    bindkey          "$terminfo[kcub1]" backward-char
    bindkey -M vicmd "$terminfo[kcub1]" backward-char
fi
# right arrow (whichwrap)
if [[ -n $terminfo[kcuf1] ]]; then
    bindkey          "$terminfo[kcuf1]" forward-char
    bindkey -M vicmd "$terminfo[kcuf1]" forward-char
fi

# fancy <C-z>
bindkey              '^Z'               fancy-ctrl-z
bindkey -M vicmd     '^Z'               fancy-ctrl-z

bindkey '\ew' kill-region
bindkey -s '\el' "ls\n"
bindkey '^r' history-incremental-search-backward
bindkey "^[[5~" up-line-or-history
bindkey "^[[6~" down-line-or-history

# make search up and down work, so partially type and hit up/down to find relevant stuff
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search

bindkey "^[[H" beginning-of-line
bindkey "^[[1~" beginning-of-line
bindkey "^[OH" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[4~" end-of-line
bindkey "^[OF" end-of-line
bindkey ' ' magic-space # also do history expansion on space

bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

bindkey '^[[Z' reverse-menu-complete

# Make the delete key (or Fn + Delete on the Mac) work instead of outputting a ~
bindkey '^?' backward-delete-char
bindkey "^[[3~" delete-char
bindkey "^[3;5~" delete-char
bindkey "\e[3~" delete-char

case "$TERM" in
    vte*|xterm*|rxvt*)
        precmd() { print -Pn '\e];Terminal: %n (%~)\a' } ;;
esac

setopt LONG_LIST_JOBS     # List jobs in the long format by default.
setopt AUTO_RESUME        # Attempt to resume existing job before creating a new process.
setopt NOTIFY             # Report status of background jobs immediately.
unsetopt BG_NICE          # Don't run all background jobs at a lower priority.
unsetopt HUP              # Don't kill jobs on shell exit.
unsetopt CHECK_JOBS       # Don't report on jobs when shell exit.

# changing directories
setopt auto_cd
setopt auto_pushd
setopt cdable_vars
setopt chase_links
setopt pushd_ignore_dups
setopt pushd_silent
setopt pushd_to_home

# completion
setopt always_to_end
setopt auto_menu
setopt auto_name_dirs
setopt auto_param_keys
setopt auto_param_slash
setopt auto_remove_slash
setopt complete_aliases
setopt complete_in_word
setopt list_ambiguous
setopt list_packed
unsetopt menu_complete

# expansion and globbing
setopt extended_glob
setopt long_list_jobs
setopt multios
setopt prompt_subst

# input/output
setopt correctall
unsetopt clobber
unsetopt flowcontrol
setopt interactive_comments
setopt rc_quotes
setopt short_loops

unset isroot app
eval $(dircolors -b ~/.dir_colors)

export \
BROWSER="chromium" \
GPGKEY=2C3985CD

#export CC=gcc CXX=g++
export \
CC=clang \
CXX=clang++ \
CFLAGS="-march=native -mfpmath=sse -O3 -pipe -fstack-protector -D_FORTIFY_SOURCE=2 -fuse-linker-plugin" \
CXXFLAGS="-std=gnu++11 $CFLAGS" \
LDFLAGS="-Wl,-O1,--sort-common,--as-needed,-z,relro" \
MAKEFLAGS="-j2"

export \
EDITOR='nano' \
VISUAL='nano' \
PAGER='less'

export \
LESSHISTFILE=- \
LESS=-R        \
GREP_OPTIONS='--color=auto'

export \
LESS_TERMCAP_mb=$'\E[01;31m'    \
LESS_TERMCAP_md=$'\E[01;31m'    \
LESS_TERMCAP_me=$'\E[0m'        \
LESS_TERMCAP_se=$'\E[0m'        \
LESS_TERMCAP_so=$'\E[00;47;30m' \
LESS_TERMCAP_ue=$'\E[0m'        \
LESS_TERMCAP_us=$'\E[01;32m'    \

source $HOME/.zfunctions
source $HOME/.zprivate
