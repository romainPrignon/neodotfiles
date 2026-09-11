#! /bin/sh
set -euo pipefail

# print new line between commands
trap 'echo' DEBUG

whoami
groups
hostname
localectl
timedatectl
lsblk
cat /etc/apt/sources.list /etc/apt/sources.list.d/*
systemctl | grep running
env
