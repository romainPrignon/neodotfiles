if [ -f "$HOME/.env" ]; then
    source "$HOME/.env"
fi

if [ -n "$BASH_VERSION" ]; then
    if [ -f "$HOME/.bashrc" ]; then
    source "$HOME/.bashrc"
    fi
fi

# 2 => `
if [[ $DISPLAY ]]; then
  xmodmap -e "keycode 49 = grave"
fi

# caps_lock => <>
if [[ $DISPLAY ]]; then
  xmodmap -e "keycode 66 = less greater"
fi
