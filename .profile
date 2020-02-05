# Compose key doesn't work without this
export GTK_IM_MODULE=xim

# QGtkStyle needs this to detect the current theme
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"

# Set default shell.  I still want my login shell to be bash since that is used
# to run ~/.xsession
export SHELL=/usr/bin/fish

# Editor
export EDITOR=emacs

# Update path
PATH=\
/usr/local/bin:\
/usr/bin:\
/bin:\
/usr/local/sbin:\
/usr/sbin:\
/sbin:\
/usr/local/games:\
/usr/games

addbins () {
    while read -r -d $'\0' dir ; do
        if [ -d "$dir/bin" ] ; then
            PATH="$dir/bin:$PATH"
        fi
    done < <(find "$1" -maxdepth 1 -type d -print0)
}

addbins "$HOME"
addbins "/opt"
export PATH
