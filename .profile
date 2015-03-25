# proper man section order for a brogrammer
export MANSECT=2:3:1:4:5:6:7:8:9

# Set up common programs
export PAGER=less
export EDITOR=emacs
export BROWSER=chromium

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
        export PATH=$PATH:$d
    fi
done

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
  . "$HOME/.bashrc"
    fi
fi
