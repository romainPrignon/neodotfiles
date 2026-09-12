if [ -f "$HOME/.env" ]; then
    source "$HOME/.env"
fi

if [ -f "$HOME/.zshrc" ]; then
    source "$HOME/.zshrc"
fi

# 2 => `
if [[ $DISPLAY ]]; then
  xmodmap -e "keycode 49 = grave"
fi

# caps_lock => <>
if [[ $DISPLAY ]]; then
  xmodmap -e "keycode 66 = less greater"
fi
