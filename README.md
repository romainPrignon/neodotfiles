# dotfiles

Personal workstation provisioning and dotfiles.

## dependencies

- `curl`
- `git`
- `make`

## guidelines

- Create dedicated targets for components that are optional, require pinned versions, or need custom config; use `-all` targets otherwise.
- Prefer targeted updates over running blanket update commands.

## install

### automation

1. Clone the repository:
   ```bash
   git clone https://github.com/romainPrignon/dotfiles.git ~/.dotfiles
   cd ~/.dotfiles
   ```
2. Configure distribution and version:
   ```bash
   cp .env.example .env
   # Edit DIST (e.g., debian, ubuntu) and VERSION (e.g., trixie, noble)
   ```
3. Run the provisioning pipeline:
   ```bash
   make swap size=8G # Optional: create swap
   make grub         # configure grub
   make bootstrap    # Create folder hierarchy
   make install      # Install system packages, runtimes, and CLI tools
   make configure    # Link dotfiles and configurations
   make load-desktop # Load dconf settings
   make checkup      # Verify installed tools
   sudo reboot       # Apply shell and group changes
   make clean        # Clean caches
   ```

### manual

- Open `chrome://apps/` or `brave://apps/` and install shortcuts (DevDocs, Spotify, YouTube).
- Launch and log in to Insync.
- Configure gitmoji:
  ```bash
  gitmoji -g
  ```
- Link partner configuration if applicable:
  ```bash
  make partner partner=<partner-name>
  ```

## routine

- Run targeted updates: `make update-cli`, `make update-runtime`, `make update-pkger`, `make update-app`.
- Update all packages: `make update`.
- Clean package caches and logs: `make clean`.
- Prune unused mise tools: `make purge`.

## troubleshooting

- **Display scaling**: switch to GNOME on Xorg at login screen, or set a higher resolution and scale down on Wayland.
- **Verification**: run `make checkup` to validate missing binaries or paths.

## contribute

- Switch to SSH remote (producer mode): `make produce`.
- Switch to HTTPS remote (consumer mode): `make consume`.
- Build container test environment: `make build dist=debian version=trixie`.
- Run container test environment: `make dev dist=debian version=trixie`.
- Sync files to local VM via SSH: `make sync`.
