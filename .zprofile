export \
BROWSER=chromium     \
EDITOR=nano          \
VISUAL=nano          \
LANG=en_US.UTF-8     \
LC_CTYPE=en_US.UTF-8 \
PAGER=less           \
LESSHISTFILE=-       \
LESS=-R              \
GREP_COLOR="4;1;31"  \
LESS_TERMCAP_mb=$'\E[01;31m'    \
LESS_TERMCAP_md=$'\E[01;31m'    \
LESS_TERMCAP_me=$'\E[0m'        \
LESS_TERMCAP_se=$'\E[0m'        \
LESS_TERMCAP_so=$'\E[00;44;33m' \
LESS_TERMCAP_ue=$'\E[0m'        \
LESS_TERMCAP_us=$'\E[01;32m'    \
MALLOC_CHECK_=1 \
PATH="$HOME/bin:/opt/qt5/bin:/usr/lib/colorgcc/bin:$PATH"

#CC=$HOME/bin/gcc
#CXX=$HOME/bin/g++
CC=gcc
CXX=g++

CFLAGS="-O2 -pipe -march=native -msse -msse2 -msse3 -mmmx -Wno-unused-result"
CFLAGS+=" -flto -fuse-linker-plugin"
CFLAGS+=" -fstack-protector -D_FORTIFY_SOURCE=2 --param=ssp-buffer-size=4"

LDFLAGS="-Wl,-O1,--sort-common,--as-needed,--hash-style=gnu,-z,relro"
LDFLAGS+=" -flto"

export CFLAGS CXXFLAGS="${CFLAGS}" LDFLAGS CC CXX
export MAKEFLAGS="-j2"
