# dotfiles

> personal dotfiles

## dependencies
 - curl
 - git
 - make

## makefile guidelines
if a component is optional/need pinned version/need config => do a dedicated make target, put in `-all` target otherwise

## 🚀 Quickstart (New Machine / Fresh Install)

### 1. Clone the repository
```bash
git clone https://github.com/romainPrignon/neodotfiles.git ~/workspace/romainprignon/neodotfiles
cd ~/workspace/romainprignon/neodotfiles
```

### 2. Configure Environment
Set target distribution and version either via environment variables or a `.env` file:

```bash
cp .env.example .env
# Edit .env to adjust DIST and VERSION (e.g., DIST=debian, VERSION=trixie)
```

Alternatively, export variables directly in your shell:
```bash
export DIST=debian
export VERSION=trixie
```

### 3. Run the Provisioning Pipeline (in order)

- first, clean primary targets to install only what you need

| Step | Command | Description |
|---|---|---|
| **0. (Optional)** | `make swap` | Set up swap space (recommended for low RAM / cloud VMs) |
| **1. Bootstrap** | `make bootstrap` | Install base build tools and essential utilities |
| **2. Install** | `make install` | Install all packages and CLI tools for the target OS |
| **3. Configure** | `make configure` | Apply configurations and create symlinks |
| **3. Desktop** | `make load-desktop` | Apply Desktop configurations |
| **4. Checkup** | `make checkup` | Validate that all tools and configs are working properly |
| **5. (Optional)** | `make produce` | Install additional developer/power-user tools (producer mode) |
| **6. Reboot** | `sudo reboot` | Reboot system to ensure all shell/group changes take effect |
| **7. Clean** | `make clean` | Clean up package caches and temporary install artifacts |

---

## 🔄 Routine Maintenance

Keep packages and dotfiles up to date:

```bash
make update # (not safe)
```

- prefer targeted updates

## contribute

TOOD: explain make contribute target
