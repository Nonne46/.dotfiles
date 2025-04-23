#!/bin/bash
set -xe

PACMAN='sudo pacman -S --needed'
YAY='yay -S --needed'
GIT='git clone --depth 1 --single-branch'
RUSTC='rustc -C link-arg=-Wl,--gc-sections -C opt-level=z -C lto -C codegen-units=1 -C panic=abort -C target-cpu=native -C debuginfo=0 -C strip=debuginfo -C strip=symbols --target=x86_64-unknown-linux-musl -o'
export LINKDOT=$PWD

# Install yay
if ! command -v yay 2>&1 > /dev/null
then
	$PACMAN git base-devel
	cd /tmp/
	$GIT https://aur.archlinux.org/yay.git
	cd yay
	makepkg -si
	cd "$LINKDOT"
fi

packages=(
	# Main impact
	bspwm sxhkd dmenu polybar picom
	dunst alacritty xorg-xinit polkit-gnome

	# X shit
	xorg-xrandr xorg-xsetroot xorg-xprop xorg-server
	xclip xcursor-pixelfun-all warpd

	# Font shit
	ttf-croscore ttf-fantasque-sans-mono ttf-iosevka
	ttf-joypixels ttf-linux-libertine ttf-sarasa-gothic
	noto-fonts noto-fonts-cjk noto-fonts-emoji

	# File manager shit
	thunar thunar-volman thunar-archive-plugin 	tumbler
	yazi xdg-desktop-portal xdg-desktop-portal-termfilechooser-hunkyburrito-git

	# Filesystems shit
	gvfs gvfs-mtp gvfs-nfs gvfs-smb
	ntfs-3g btrfs-progs squashfs-tools

	# Audio shit
	# pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber alsa-utils pamixer

	# Bluetooth shit
	# bluez bluez-util
	
	# Archive shit
	lrzip lzip unrar unzip 7zip tar pigz zstd pbzip2
	xz lzop lz4 ncompress

	# Modern cli shit
	bat jq fd fzf ripgrep eza dust sd tealdeer btop gnupg
	hyperfine xh zoxide ffmpeg imagemagick ueberzugpp hexyl
	neovim fish at

	# Multimedia shit
	mpv zathura zathura-pdf-mupdf mpd feh flameshot

	# Compilers
	rustup go
)

$YAY "${packages[@]}"

echo "Are you sure you're not a traitor? [y/N]"
read -r decrypt
if [[ $decrypt == "y" || $decrypt == "Y" ]]; then
	echo "Planting miner... Asking for confirmation..."
	gpg --pinentry-mode loopback --decrypt "$LINKDOT"/other/.dotfiles_env.gpg > "$LINKDOT"/home/.dotfiles_env
	chmod 600 "$LINKDOT"/home/.dotfiles_env
	echo "Miner planted. Have fun!"
else
	echo "I'll bruteforce it someday..."
fi

# Setup rust
if command -v rustc &>/dev/null &&
	! rustup show active-toolchain &>/dev/null
then
    rustup default stable
    rustup target add x86_64-unknown-linux-musl
fi

# Compile some shit
$RUSTC "$LINKDOT"/config/menu/dmenu_frun "$LINKDOT"/config/menu/dmenu_frun.rs

# Create folders
mkdir -p "$HOME"/.config "$HOME"/Images/Captures "$HOME"/Images/Wallpapers "$LINKDOT"/config/mpd/playlists ~ "$HOME"/Music

# Copy configs
ln -sfv "$LINKDOT"/home/.* "$HOME"
ln -sfv "$LINKDOT"/config/* "$HOME"/.config/
ln -sfv "$LINKDOT"/other/index.theme "$HOME"/.icons/default
ln -sfv "$LINKDOT"/other/*.fish "$HOME"/.config/fish/conf.d/

# Copy wallpapers
cp -n wallpapers/* ~/Images/Wallpapers

# Set permission
chmod +x ~/.config/bspwm/bspwmrc
chmod +x ~/.config/menu/launcher

echo "-- Installation Complete! Restart the computer."
