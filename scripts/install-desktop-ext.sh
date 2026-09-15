#! /bin/sh

set -euo pipefail

curl -fsSL -H "User-Agent: Mozilla/5.0" "https://extensions.gnome.org/extension-data/$1.shell-extension.zip" -o /tmp/$1.zip
gnome-extensions install --force /tmp/$1.zip
