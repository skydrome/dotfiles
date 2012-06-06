extract() {
    local extract_dir="$( echo "$file_name" | sed "s/\.${1##*.}//g" )"
    for i in "$@" ;do
    case "$1" in
      *.tar.gz|*.tgz        ) tar xzf "$1" ;;
      *.tar.bz2|*.tbz|*.tbz2) tar xjf "$1" ;;
      *.tar.xz|*.txz        ) tar --xz --help &> /dev/null &&
                              tar --xz -xf "$1" ||
                              xzcat "$1" | tar xf - ;;
      *.tar.zma|*.tlz       ) tar --lzma --help &> /dev/null &&
                              tar --lzma -xf "$1" ||
                              lzcat "$1" | tar xf - ;;
      *.tar.lrz) lrzuntar    "$1" ;;
      *.lrz    ) lrunzip     "$1" ;;
      *.tar    ) tar xf      "$1" ;;
      *.gz     ) gunzip      "$1" ;;
      *.bz2    ) bunzip2     "$1" ;;
      *.xz     ) unxz        "$1" ;;
      *.lzma   ) unlzma      "$1" ;;
      *.Z      ) uncompress  "$1" ;;
      *.zip    ) local extract_dir="$(echo $(basename "$1") | sed "s/\.${1##*.}//g")"
                 unzip       "$1" -d $extract_dir ;;
      *.rar    ) unrar e -ad "$1" ;;
      *.7z     ) 7za x       "$1" ;;
      *.Z      ) uncompress  "$1" ;;
      *) echo "extract: '$1' cannot be extracted" 1>&2 ;;
    esac
    done
}
extract_dir() {
    for FILE in $(find -type -f *); do
        extract $FILE
    done
}
sizeofdir() { # show size of all directories in current working directory
    du -shx * .[a-zA-Z0-9_]* 2> /dev/null | \
        egrep '^ *[0-9.]*[MG]' | sort -n > /tmp/list
        egrep '^ *[0-9.]*M' /tmp/list
        egrep '^ *[0-9.]*G' /tmp/list
    rm /tmp/list
}

start()   { for arg in $* ;do sudo /etc/rc.d/$arg start   ;done ;}
stop()    { for arg in $* ;do sudo /etc/rc.d/$arg stop    ;done ;}
restart() { for arg in $* ;do sudo /etc/rc.d/$arg restart ;done ;}
reload()  { for arg in $* ;do sudo /etc/rc.d/$arg reload  ;done ;}

alias sizeof='du -sh'
alias df='df -h -T --total'

alias ls="ls -lha -A --color"
alias lt="ls -rt"           # sort by modification time
alias lw="ls -1"            # windows-style list
alias lx="ls -BX"           # sort by extension
alias ly="ls -rS"           # sort by size

alias ns='netstat -alnp --protocol=inet | grep -v CLOSE_WAIT | cut -c-6,21-94 | tail'
alias nsw='sudo watch -n 3 -d -t netstat -vantp'
alias openports='netstat --all --numeric --programs --inet'

alias nightmode='xflux -z 27613'
alias axel='axel -a'
alias wget='axel'
alias ccopt='gcc -c -Q -O3 --help=optimizers | grep enabled'
alias ed='pluma'
alias findcpu='echo "" | gcc -march=native -v -E - 2>&1 | grep cc1'
alias ns="netstat -alnp --protocol=inet | grep -v CLOSE_WAIT | cut -c-6,21-94 | tail"
alias nsw="sudo watch -n 3 -d -t netstat -vantp"    # watch incoming connections
alias openports="netstat --all --numeric --programs --inet"
alias rsynn="rsync -r -n -t -p -o -g -v --progress --delete -l"
alias chx='chmod +x'
alias chfile='chmod 644'
alias chdir='chmod 755'
alias less="less -iF"
alias more="less"

alias syntaxcheck='for file in $(find $1 -iname "*.sh"); do bash -n $file ;done'
alias traceroute='grc -s traceroute-for-linux'
alias netstat='grc -s netstat'
alias ping='grc -s ping -c 5'

rtorrent_start() {
    dtach -n ~/.dtach/rtorrent rtorrent
    [[ ! -z $(pgrep -u "$USER" "rtorrent") ]] &&
        echo "rtorrent start successfully" || echo "rtorrent failed to start"
}
rtorrent_resume() { dtach -a .dtach/rtorrent ;}

export TERM=xterm-256color
export CC=gcc CXX=g++ \
       CFLAGS="-march=native -mtune=native -mfpmath=sse -O3 -pipe -fstack-protector-all -D_FORTIFY_SOURCE=2 --param=ssp-buffer-size=4" CXXFLAGS="-std=gnu++11 $CFLAGS" \
       LDFLAGS="-Wl,-O1,--sort-common,--as-needed,-z,relro,-z,now" \
       MAKEFLAGS="-j2"
export PKG_CONFIG=/usr/bin/pkgconf
#export PATH="~/bin:$PATH"
export OWL_SUDO_WARN=false BROWSER=firefox-nightly XDG_AUR_HOME=~/src/aur

source ~/.private
