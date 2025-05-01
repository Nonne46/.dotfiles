#!/bin/bash
set -xeu

PACMAN='sudo pacman -S --needed'
YAY='yay -S --needed'
GIT='git clone --depth 1 --single-branch'
RUSTC='rustc -C link-arg=-Wl,--gc-sections -C opt-level=z -C lto -C codegen-units=1 -C panic=abort -C target-cpu=native -C debuginfo=0 -C strip=debuginfo -C strip=symbols -o'
LINKDOT=$PWD

[[ ! -f "${LINKDOT}/install.sh" ]] && exit 1

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
	dunst alacritty polkit-gnome

	# X shit
	xorg-xrandr xorg-xsetroot xorg-xprop xorg-server
	xorg-xinit xclip xcursor-pixelfun-all warpd

	# Font shit
	ttf-croscore ttf-fantasque-sans-mono ttf-iosevka
	ttf-joypixels ttf-linux-libertine ttf-sarasa-gothic
	noto-fonts noto-fonts-cjk noto-fonts-emoji

	# File manager shit
	thunar thunar-volman thunar-archive-plugin tumbler
	yazi

	# Filesystems shit
	gvfs gvfs-mtp gvfs-nfs gvfs-smb
	ntfs-3g btrfs-progs squashfs-tools

	# Audio shit
	pipewire pipewire-jack pipewire-pulse wireplumber

	# Bluetooth shit
	# bluez bluez-util blueman
	
	# Archive shit
	lrzip lzip unrar unzip 7zip tar pigz zstd pbzip2
	xz lzop lz4 ncompress

	# Modern cli shit
	bat jq fd fzf ripgrep eza dust sd tealdeer btop gnupg
	hyperfine xh zoxide ffmpeg imagemagick ueberzugpp hexyl
	neovim fish at feh flameshot yt-dlp

	# PDF shit
	zathura zathura-cb zathura-pdf-poppler

	# Multimedia shit
	mpv mpd

	# Compilers
	rustup go gcc make patch
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
