# Filename:      zshenv
# Purpose:       system-wide .zshenv file for zsh(1)
# Authors:       grml-team (grml.org)
# Massive edits, additions, deletions, and updates/upgrade were required to 
# get the code to function at all, if not correctly, these edits are an amalgam
# of original code, from additional open sources, and grml's own zsh-lovers. 
# The edits, cuts, slashes, slices, and repeated testing done by drpdead@github aka dropDEADRedd
# License:       This file is licensed under Beerware
################################################################################
# no xsource() here because it's only created in zshrc! (which is good)
[[ -r /etc/environment ]] && source /etc/environment

# set environment variables (important for autologin on tty)
if [ -n "${HOSTNAME}" ] ; then
    export HOSTNAME="${HOSTNAME}"
else
    export HOSTNAME="Victim15"
fi

# make sure /usr/bin/id is available
if [[ -x /usr/bin/id ]] ; then
    [[ -z "$USER" ]] && export USER=$(/usr/bin/id -un)
    [[ $LOGNAME == LOGIN ]] && LOGNAME=$(/usr/bin/id -un)
fi
    
# generic $PATH handling
if (( EUID != 0 )); then
  path=(
    $HOME/bin
    /usr/local/bin
    /usr/bin
    /bin
    /usr/local/sbin
    /usr/sbin
    /sbin
    /usr/local/games
    /usr/games
    $HOME/bin
    $HOME/.bin
    $HOME/go/bin
    $HOME/.cargo/bin
    $HOME/.local/bin
    "${ADDONS}"
    "${path[@]}"
  )
else
  path=(
    $HOME/bin
    /usr/local/sbin
    /usr/local/bin
    /sbin
    /bin
    /usr/sbin
    /usr/bin
    /var/lib/flatpak/exports/bin/
    "${ADDONS}"
    "${path[@]}"
  )
fi

# remove empty components to avoid '::' ending up + resulting in './' being in $PATH
path=( "${path[@]:#}" ) 

typeset -U path

# less (:=pager) options:
#  export LESS=C
typeset -a lp; lp=( ${^path}/lesspipe(N) )
if (( $#lp > 0 )) && [[ -x $lp[1] ]] ; then
    export LESSOPEN="|lesspipe %s"
elif [[ -x /usr/bin/lesspipe.sh ]] ; then
    export LESSOPEN="|lesspipe.sh %s"
fi
unset lp

export READNULLCMD=${PAGER:-/usr/bin/pager}
# allow zeroconf for distcc
export DISTCC_HOSTS="+zeroconf"
# MAKEDEV should be usable on udev as well by default:
export WRITE_ON_UDEV=yes
ZDOTDIR=${ZDOTDIR:-${HOME}}
ZSHDDIR=${ZSHDDIR:-${ZDOTDIR}/.zsh}
FIZSHDIR=${FIZSHDIR:-${ZSHDDIR}/.fizsh}
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_STATE_HOME="${HOME}/.local/state"
export XDG_CONFIG_DIRS="/etc/xdg"
export XDG_DATA_DIRS="/usr/local/share:/usr/share:/var/lib/flatpak/exports/share:${XDG_DATA_HOME}/flatpak/exports/share"
export XDG_DOWNLOAD_DIR="${HOME}/Downloads"
export XDG_PICTURES_DIR="${HOME}/Pictures"
export EDITOR="/usr/bin/nvim"
export BROWSER="msedge"
export VISUAL="nvim"
export TMP="$HOME/tmp"
export TEMP="$TMP"
export TMPDIR="$TMP"
export TMPPREFIX="${TMPDIR}/zsh"
if [ ! -d "${TMP}" ]; then mkdir "${TMP}"; fi
# Use hostname in TMUX_TMPDIR as $HOME may be on nfs.
export TMUX_TMPDIR="${TMPDIR}/tmux-${HOST}-${UID}"
if [ ! -d "${TMUX_TMPDIR}" ]; then mkdir -p "${TMUX_TMPDIR}"; fi
# history
#v#
HISTFILE=${HISTFILE:-${ZDOTDIR:-${HOME}}/.zsh_history}
HISTSIZE=5000
SAVEHIST=10000 # useful for setopt append_history
# dirstack handling
DIRSTACKSIZE=${DIRSTACKSIZE:-20}
DIRSTACKFILE=${DIRSTACKFILE:-${ZDOTDIR:-${HOME}}/.zdirs}

## END OF FILE #################################################################
# vim:filetype=zsh foldmethod=marker autoindent expandtab shiftwidth=4





