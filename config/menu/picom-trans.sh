#!/bin/bash

set -xe

# window-opacity.sh - A script to control window opacity with picom-trans
# Usage: ./window-opacity.sh [increase|decrease] [amount]

DEFAULT_STEP=10

ACTION="$1"

AMOUNT="${2:-$DEFAULT_STEP}"

CURRENT=$(picom-trans -c -g)

if [ "$ACTION" = "increase" ]; then
    NEW=$((CURRENT + AMOUNT))
    [ $NEW -gt 100 ] && NEW=100
elif [ "$ACTION" = "decrease" ]; then
    NEW=$((CURRENT - AMOUNT))
    [ $NEW -lt 0 ] && NEW=0
else
    echo "Error: First argument must be 'increase' or 'decrease'"
    echo "Usage: $0 [increase|decrease] [amount]"
    exit 1
fi

picom-trans -c -o $NEW

echo "Changed window opacity from $CURRENT% to $NEW%"
