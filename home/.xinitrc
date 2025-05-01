#!/bin/sh

userresources="$HOME"/.Xresources
usermodmap="$HOME"/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

[ -z "$XDG_CONFIG_HOME" ] && export XDG_CONFIG_HOME="$HOME/.config"
[ -z "$XDG_CACHE_HOME" ] && export XDG_CACHE_HOME="$HOME/.cache"

export XDG_SESSION_TYPE="x11"
export XDG_SESSION_DESKTOP="bspwm"
export XDG_CURRENT_DESKTOP="bspwm"

export DESKTOP_SESSION="bspwm"
export WINDOW_MANAGER="bspwm"

[ -f "$HOME/.dotfiles_env" ] && source "$HOME/.dotfiles_env"

if [ -f "$sysresources" ]; then
	xrdb  -merge "$sysresources"
fi

if [ -f "$sysmodmap" ]; then
	xmodmap  "$sysmodmap"
fi

if [ -f "$userresources" ]; then
	xrdb  -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
	xmodmap  "$usermodmap"
fi

if [ -d /etc/X11/xinit/xinitrc.d ]; then
	for f in /etc/X11/xinit/xinitrc.d/?*.sh; do
		[ -x "$f" ] && . "$f"
	done
	unset f
fi

xsetroot -cursor_name left_ptr

exec bspwm
