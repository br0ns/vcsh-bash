# stole some stuff from
#  http://tldp.org/LDP/abs/html/sample-bashrc.html
#  https://gist.github.com/31631
#  http://mediadoneright.com/content/ultimate-git-ps1-bash-prompt

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# them colors
export TERM=xterm-256color

# history
HISTCONTROL=ignoreboth
HISTFILESIZE=50000
HISTSIZE=50000

# options
shopt -s cdspell
shopt -s globstar
shopt -s histappend
shopt -s checkwinsize
shopt -u mailwarn
unset MAILCHECK

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# colors
# Normal Colors
Black='\e[0;30m'        # Black
Red='\e[0;31m'          # Red
Green='\e[0;32m'        # Green
Yellow='\e[0;33m'       # Yellow
Blue='\e[0;34m'         # Blue
Purple='\e[0;35m'       # Purple
Cyan='\e[0;36m'         # Cyan
White='\e[0;37m'        # White

# Bold
BBlack='\e[1;30m'       # Black
BRed='\e[1;31m'         # Red
BGreen='\e[1;32m'       # Green
BYellow='\e[1;33m'      # Yellow
BBlue='\e[1;34m'        # Blue
BPurple='\e[1;35m'      # Purple
BCyan='\e[1;36m'        # Cyan
BWhite='\e[1;37m'       # White

# Background
On_Black='\e[40m'       # Black
On_Red='\e[41m'         # Red
On_Green='\e[42m'       # Green
On_Yellow='\e[43m'      # Yellow
On_Blue='\e[44m'        # Blue
On_Purple='\e[45m'      # Purple
On_Cyan='\e[46m'        # Cyan
On_White='\e[47m'       # White

NC="\e[m"               # Color Reset

ALERT=${BWhite}${On_Red} # Bold White on red background

# git info
PS1='$(git branch &>/dev/null;\
# in a git repo
if [ $? -eq 0 ]; then \
    n=$(git stash list --no-color 2>/dev/null | wc -l | tr -d "\\n") ; \
    if [ "$n" -ne "0" ] ; then \
        echo -ne "\[${BRed}\]${n}\[${NC}\]:" ; \
    fi ; \
    echo "$(echo `git status` | grep "nothing to commit" > /dev/null 2>&1; \
  if [ "$?" -eq "0" ]; then \
    # Clean repository - nothing to commit
    echo $(__git_ps1 "\[${Green}\]%s\[${NC}\]"); \
  else \
    # Changes to working tree
    echo $(__git_ps1 "\[${Red}\]%s\[${NC}\]"); \
  fi):"; \
# not in a git repo
else \
  echo ""; \
fi)'

# vcsh dirty?
PS1="$PS1"'$([ "$HOME" == "`pwd`" ] && vcsh status | grep -q " " && \
echo -e "\[${ALERT}\]!\[${NC}\]")'

if [[ ${USER} == "root" ]]; then
    PS1="${PS1}\[${Yellow}\]\h\[${NC}\]:\[${ALERT}\]\w\[${NC}\]"
else
    if [ -n "${SSH_CONNECTION}" ]; then
        PS1="${PS1}\[${Yellow}\]\h\[${NC}\]:"
    fi
    PS1="${PS1}\[${BBlue}\]\w\[${NC}\]"
fi

PS1="${PS1}> "

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# aliases
alias e=emacs
alias et='/usr/bin/env emacs -nw -q --no-splash'
alias g=git
alias l='ls -hCF --group-directories-first'
alias ll='l -l'
alias la='l -A'
alias lla='l -lA'
alias mkdir='mkdir -pv'
alias gdb='gdb -n -x ~/.gdbinit'
alias strings='strings -a'
alias hexdump='hexdump -Cv'

alias .1='cd ..'
alias .2='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'
alias ..=.1
alias ...=.2
alias ....=.3

alias nc='rlwrap nc'
alias mosml='rlwrap mosml'
alias sml='rlwrap sml'

# lightweight "bookmarks"
# current directory is implicitly marked
# r rotates marked directories
alias r='pushd -1'
# f swaps/flips directories at top of list
alias s='pushd'
# m marks current directory
alias m='pushd .'
# p unmarks/pops current directory
alias p='popd'

# $HOME is marked initially
m > /dev/null

# alias-like functions

function mkdircd () {
    mkdir -pv "$@" && eval cd "\"\$$#\"";
}

function pwnthon () {
    if [[ "$1" == "doit.py" ]] ; then
        command python "$@" LOG_FILE=doit.log
    else
        command python "$@"
    fi
}

function emacs () {
    (/usr/bin/env emacs --no-splash $@ </dev/null >/dev/null 2>/dev/null &)
}

function ida () {
    if file "$1" | grep -q 64-bit ; then
        (idaq64 "$1" &)
    else
        (idaq "$1" &)
    fi
}

function mdv () {
    chromium --app="file://$(realpath "$@")"
}

function doit () {
    if [ ! -f doit.py ] ; then
        cat > doit.py <<EOF
#!/usr/bin/env python2
from pwn import *
context(arch = 'i386')

EOF
        chmod +x doit.py
    fi
    emacs doit.py +3
}

# <o>bjectdump -<d> | <l>ess
function odl () {
    objdump -dMintel "$1" | less;
}

# <o>bjectdump -<D> | <l>ess
function oDl () {
    objdump -DMintel "$1" | less;
}

# <h>ex<d>ump | <l>ess
function hdl () {
  if [ $# -eq 0 ] ; then
    phd --color always | less -R
  else
    phd --color always "$1" | less -R
  fi
}

# <r>ead<e>lf | <l>ess
function rel () {
    readelf -a "$1" | less;
}

function RM () {
  if [ -d "$1" ]; then
    find "$1" -type f -exec shred -vu "{}" \;
    rm -rfv "$1"
  else
    shred -vu "$1"
  fi
}

# autojump
. /usr/share/autojump/autojump.bash
