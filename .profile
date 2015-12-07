# Compose key doesn't work without this
export GTK_IM_MODULE=xim

# QGtkStyle needs this to detect the current theme
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"

# Update path
export PATH=\
/usr/local/bin:\
/usr/bin:\
/bin:\
/usr/local/sbin:\
/usr/sbin:\
/sbin:\
/usr/local/games:\
/usr/games

for d in \
    "/opt/ida-6.6" \
    "$HOME/bin" \
    "$HOME/.ghc/bin" \
    "$HOME/.cabal/bin" \
    ; do
    if [ -d "$d" ] ; then
        export PATH="$d:$PATH"
    fi
done

for d in /opt/*/bin ; do
    if [ "$d" != "/opt/*/bin" ]; then
        export PATH="$PATH:$d"
    fi
done
