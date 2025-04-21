#!/bin/bash
set -xe

LINKDOT=$PWD

PLAINTEXT="$LINKDOT"/home/.dotfiles_env
ENCRYPTED="$LINKDOT"/other/.dotfiles_env.gpg

if [[ ! -f "$PLAINTEXT" ]]; then
    echo "No .dotfiles_env file found at $PLAINTEXT"
    exit 1
fi

echo "Encrypting .dotfiles_env..."
gpg --symmetric --cipher-algo AES256 --output "$ENCRYPTED" "$PLAINTEXT"

if [[ $? -eq 0 ]]; then
    echo $ENCRYPTED
else
    echo "Your scheise failed. Cry."
    exit 1
fi

