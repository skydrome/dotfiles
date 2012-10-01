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
MALLOC_CHECK_=1 \
PATH="$HOME/bin:/usr/lib/colorgcc/bin:/bin:$PATH"

CC=gcc
CXX=g++

COREFLAGS=
COREFLAGS+=' -frename-registers'
COREFLAGS+=' -ftree-vectorize'
COREFLAGS+=' -fweb'
COREFLAGS+=' -fomit-frame-pointer'
COREFLAGS+=' -freorder-blocks'
COREFLAGS+=' -fno-ident'
COREFLAGS+=' -fmerge-all-constants'
COREFLAGS+=' -ftree-loop-im'
COREFLAGS+=' -fgcse-after-reload'
COREFLAGS+=' -mfpmath=sse'
COREFLAGS+=' -msahf'

CPUFLAGS='-march=native -msse -msse2 -msse3 -mmmx'

CFLAGS="-O3 -pipe ${CPUFLAGS} ${COREFLAGS}"
#CFLAGS+=" -flto -fuse-linker-plugin"
CFLAGS+=" -fstack-protector -D_FORTIFY_SOURCE=2 --param=ssp-buffer-size=4"

LDFLAGS="-Wl,-O1,--sort-common,--as-needed,--hash-style=gnu,-z,relro"
#LDFLAGS+=" -flto"

export CXXFLAGS="${CFLAGS}" CFLAGS LDFLAGS CC CXX
export MAKEFLAGS="-j2"