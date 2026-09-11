if [ -f "$HOME/.env" ]; then
    source "$HOME/.env"
fi

if [ -n "$BASH_VERSION" ]; then
    if [ -f "$HOME/.bashrc" ]; then
    source "$HOME/.bashrc"
    fi
fi
