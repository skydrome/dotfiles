export BROWSER="chromium"
export GPGKEY=2C3985CD

#export CC=gcc CXX=g++
export CC=clang CXX=clang++
export CFLAGS="-march=native -mfpmath=sse -O3 -pipe -fstack-protector -D_FORTIFY_SOURCE=2 -fuse-linker-plugin"
export CXXFLAGS="-std=gnu++11 $CFLAGS"
export LDFLAGS="-Wl,-O1,--sort-common,--as-needed,-z,relro"
export MAKEFLAGS="-j2"

export LESS_TERMCAP_mb=$'\E[01;31m' # begin blinking
export LESS_TERMCAP_md=$'\E[01;31m' # begin bold
export LESS_TERMCAP_me=$'\E[0m'     # end mode
export LESS_TERMCAP_so=$'\E[01;36m' # begin standout-mode
export LESS_TERMCAP_se=$'\E[0m'     # end standout-mode
export LESS_TERMCAP_us=$'\E[00;34m' # begin underline
export LESS_TERMCAP_ue=$'\E[0m'     # end underline

sizeofdir() { # show size of all directories in current working directory
    du -shx * .[a-zA-Z0-9_]* 2> /dev/null | \
        grep '^ *[0-9.]*[MG]' | sort -n > /tmp/list
        grep '^ *[0-9.]*M' /tmp/list
        grep '^ *[0-9.]*G' /tmp/list
    rm /tmp/list
}
mcd() {
  mkdir -p "$1" && cd "$1"
}

start()   { for arg in $* ;do sudo systemctl start   $arg ;done ;}
stop()    { for arg in $* ;do sudo systemctl stop    $arg ;done ;}
restart() { for arg in $* ;do sudo systemctl restart $arg ;done ;}

alias sizeof='du -sh'
alias df='df -h -T'
alias gst='git status --short --untracked-files'
alias ls="ls --group-directories-first -lha -A"
alias md='mkdir -p'
alias rd=rmdir

alias pacman='sudo pacman-color'
alias backup='~/rsync.sh'
alias nightmode='xflux -z 11577'
alias get='axel'

alias ccopt='gcc -c -Q -O3 --help=optimizers | grep enabled'
alias findcpu='echo "" | gcc -march=native -v -E - 2>&1 | grep cc1'
alias ns="netstat -alnp --protocol=inet | grep -v CLOSE_WAIT | cut -c-6,21-94 | tail"
alias nsw="sudo watch -n 3 -d -t netstat -vantp"    # watch incoming connections
alias openports="netstat --all --numeric --programs --inet"

alias chfile='chmod 644'
alias chdir='chmod 755'
alias syntaxcheck='for file in $(find $1 -iname "*.sh"); do bash -n $file ;done'

rtorrent_start() {
    dtach -n ~/.rtorrent/rtorrent.dtach rtorrent
    [[ ! -z $(pgrep -u "$USER" "rtorrent") ]] &&
        echo "rtorrent start successfully" || echo "rtorrent failed to start"
}
rtorrent_resume() {
    dtach -a ~/.rtorrent/rtorrent.dtach
}
