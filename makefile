include .env
export

# update path for mise
export PATH := $(HOME)/.local/share/mise/shims:$(HOME)/.local/bin:$(PATH)

###### target ######
bootstrap: bootstrap-all
install: install-system install-lib install-shell install-cli install-runtime install-pkger install-pkg install-desktop install-app
configure: configure-lib configure-shell configure-cli configure-runtime configure-desktop configure-app
update: update-lib update-shell update-cli update-runtime update-desktop update-app
clean: clean-apt clean-docker clean-log clean-mise clean-pkg-node clean-pkg-python
purge: purge-mise

install-system: install-system-all install-system-tlp
install-shell: install-shell-bash install-shell-zsh
install-cli: install-cli-all install-cli-mise install-cli-mise-all install-cli-bin install-cli-fzf install-cli-micro install-cli-gh install-cli-ngrok
install-runtime: install-runtime-c install-runtime-node install-runtime-python install-runtime-rust install-runtime-go install-runtime-java install-runtime-kotlin install-runtime-docker install-runtime-packer install-runtime-terraform install-runtime-kubectl
install-pkger: install-pkger-pnpm install-pkger-uv install-pkger-poetry install-pkger-krew
install-pkg: install-pkg-docker install-pkg-node install-pkg-python install-pkg-krew
install-browser: install-browser-chrome install-browser-brave
install-app: install-app-dbgate install-app-rambox install-app-stacer install-app-virtualbox install-app-vlc install-app-vscode install-app-vscode-insiders install-app-insync install-app-yaak
install-vscode-ext: install-vscode-ext-all install-vscode-ext-node install-vscode-ext-python install-vscode-ext-gh install-vscode-ext-ai
install-vscode-insiders-ext: install-vscode-insiders-ext-all

configure-cli: configure-mise configure-locale

###### standalone ######

## create swap file if not already done ex: make swap size=8G
swap:
	sudo fallocate -l ${size} /swapfile
	sudo chmod 600 /swapfile
	sudo mkswap /swapfile
	sudo swapon /swapfile
	echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

## run a checkup after install or configure to make sure everything works
checkup:
	bash ./scripts/checkup.sh

## switch to consumer mode just to use the codebase
consume:
	git remote set-url origin https://github.com/romainPrignon/dotfiles.git

## switch to producer mode to contribute to codebase
produce:
	git remote set-url origin git@github.com:romainPrignon/dotfiles.git

###### contribute ######

## make build dist=ubuntu version=focal
build:
	docker build -t romainprignon/dotfiles:${dist}-${version} --build-arg dist=${dist} --build-arg version=${version} .

dev:
	docker run --rm -it -v ${PWD}:/home/romainprignon/.dotfiles/ romainprignon/dotfiles:${dist}-${version}

run:
	docker run --rm -it romainprignon/dotfiles:${dist}-${version}

## use to sync dotfiles to a vm with openssh-server using 2222 port
sync:
	scp -r -P 2222 ./* romainprignon@127.0.0.1:/home/romainprignon/.dotfiles/

###### bootstrap ######

bootstrap-all:
	mkdir -p ${HOME}/app
	mkdir -p ${HOME}/bin

###### install ######

install-system-all:
	@echo ====== install-system ======
	sudo apt update
	sudo apt install -y \
		coreutils \
		curl \
		git \
		make

install-system-tlp:
	@echo ====== install-system-tlp ======
	sudo apt update
	sudo apt install -y tlp

install-lib:
	@echo ====== install-lib ======
	sudo apt update
	sudo apt install -y \
		apt-transport-https \
		apt-utils \
		build-essential \
		ca-certificates \
		smartmontools
	$(MAKE) install-lib-${DIST}-${VERSION}

install-lib-debian-trixie install-lib-debian-bookworm: ;

install-lib-ubuntu-noble install-lib-ubuntu-resolute:
	@echo ====== install-lib-ubuntu ======
	sudo apt update
	sudo apt install -y \
		language-pack-en-base \
		python3-software-properties \
		software-properties-common

install-shell-bash:
	@echo ====== install-shell-bash ======
	[ -d ${HOME}/.bash-git-prompt/ ] || git clone https://github.com/magicmonty/bash-git-prompt.git ~/.bash-git-prompt --depth=1

install-shell-zsh:
	@echo ====== install-shell-zsh ======
	sudo apt update
	sudo apt install -y zsh
	mkdir -p ${HOME}/.zsh/
	[ -d ${HOME}/.zsh/zsh-autosuggestions/ ] || git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git ~/.zsh/zsh-autosuggestions
	[ -d ${HOME}/.zsh/zsh-syntax-highlighting/ ] || git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting
	[ -d ${HOME}/.zsh/zsh-git-prompt/ ] || git clone --depth=1 https://github.com/olivierverdier/zsh-git-prompt.git ~/.zsh/zsh-git-prompt
	[ -d ${HOME}/.zsh/zsh-history-substring-search/ ] || git clone --depth=1 https://github.com/zsh-users/zsh-history-substring-search ~/.zsh/zsh-history-substring-search
	[ -d ${HOME}/.zsh/fzf-tab/ ] || git clone --depth=1 https://github.com/Aloxaf/fzf-tab ~/.zsh/fzf-tab

install-cli-all:
	@echo ====== install-cli-all ======
	sudo apt update
	sudo apt install -y \
		ffmpeg \
		git-extras \
		grep \
		htop \
		jq \
		locales \
		mmv \
		net-tools \
		openssl \
		pv \
		shellcheck \
		sqlite3 \
		ssh \
		tar \
		tree \
		unzip \
		wget \
		wmctrl \
		xclip
	$(MAKE) install-cli-all-${DIST}-${VERSION}

install-cli-all-ubuntu-noble install-cli-all-ubuntu-resolute:
	@echo ====== install-cli-all-ubuntu ======
	sudo apt update
	sudo apt install -y \
		snapd

install-cli-all-debian-trixie install-cli-all-debian-bookworm: ;

install-cli-mise:
	@echo ====== install-cli-mise ======
	curl https://mise.run | sh

install-cli-mise-all:
	@echo ====== install-cli-mise-all ======
	mise use -g act@latest
	mise use -g adr-tools@latest
	mise use -g broot@latest
	mise use -g d2@latest
	mise use -g k6@latest
	mise use -g k9s@latest
	mise use -g lazydocker@latest
	mise use -g yt-dlp@latest

install-cli-ngrok:
	@echo ====== install-cli-ngrok ======
	curl -fsSL https://bin.ngrok.com/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz | tar -xz
	mv ngrok ${HOME}/bin/ngrok

install-cli-bin:
	@echo ====== install-cli-bin ======
	curl -sSL -o /tmp/bin https://github.com/marcosnils/bin/releases/download/v0.29.2/bin_0.29.2_linux_amd64
	chmod a+x /tmp/bin
	[ -x "$$(command -v bin)" ] || /tmp/bin install github.com/marcosnils/bin

install-cli-fzf:
	@echo ====== install-cli-fzf ======
	mise use -g fzf@latest

install-cli-micro:
	@echo ====== install-cli-micro ======
	mise use -g micro@latest

install-cli-gh:
	@echo ====== install-cli-gh ======
	mise use -g gh@latest

install-runtime-c:
	@echo ====== install-runtime-c ======
	sudo apt update
	sudo apt install -y \
		gcc

install-runtime-node:
	@echo ====== install-runtime-node ======
	mise install node@latest
	mise install node@lts
	mise use -g node@latest

install-runtime-python:
	@echo ====== install-runtime-python ======
	mise use -g python@latest

install-runtime-rust:
	@echo ====== install-runtime-rust ======
	mise use -g rust@latest

install-runtime-go:
	@echo ====== install-runtime-go ======
	mise use -g go@latest

install-runtime-java:
	@echo ====== install-runtime--java ======
	mise use -g java@latest

install-runtime-kotlin:
	@echo ====== install-runtime-kotlin ======
	mise use -g kotlin@latest

install-runtime-docker:
	@echo ====== install-runtime-docker ======
	curl -sSL https://get.docker.com | sh
	sudo usermod -aG docker ${USER}
	sudo apt update
	sudo apt install -y docker-buildx-plugin docker-compose-plugin

install-runtime-packer:
	@echo ====== install-runtime-packer ======
	mise use -g packer@latest

install-runtime-terraform:
	@echo ====== install-runtime-terraform ======
	mise use -g terraform@latest

install-runtime-kubectl:
	@echo ====== install-runtime-kubectl ======
	mise use -g kubectl@latest

install-pkger-pnpm:
	@echo ====== install-pkger-pnpm ======
	npm install -g pnpm

install-pkger-uv:
	@echo ====== install-pkger-uv ======
	mise use -g uv@latest

install-pkger-poetry:
	@echo ====== install-pkger-poetry ======
	mise use -g poetry@latest

install-pkger-krew:
	@echo ====== install-pkger-krew ======
	mise use -g krew@latest

install-pkg-docker:
	docker pull ${DIST}:${VERSION}
	docker pull node:lts
	docker pull node:latest
	docker pull rust:latest
	docker pull python:latest
	docker pull postgres:latest

install-pkg-node:
	npm install -g \
		depcheck \
		gitmoji-cli \
		http-server \
		json-server \
		lighthouse \
		npm-check-updates \
		tsx \
		zx

install-pkg-python:
	uv tool install --force ansible
	uv tool install --force git-machete
	uv tool install --force gnome-extensions-cli
	uv tool install --force Pygments

install-pkg-krew:
	[ -x "$$(command -v kubectl-ctx)" ] || krew install ctx
	[ -x "$$(command -v kubectl-ns)" ] || krew install ns

install-desktop:
	@echo ====== install-desktop ======
	$(MAKE) install-desktop-env
	$(MAKE) install-desktop-ext
	$(MAKE) install-font
	$(MAKE) install-gnome-app
	$(MAKE) install-browser

install-desktop-env:
	@echo ====== install-desktop-env ======
	sudo apt update
	sudo apt install -y gdm3 gnome-shell gnome-shell-extension-manager libfuse2

install-desktop-ext:
	@echo ====== install-desktop-ext ======
	gext install \
		AlphabeticalAppGrid@stuarthayhurst \
		dash-to-panel@jderose9.github.com \
		emoji-copy@felipeftn \
		escape-overview@raelgc \
		just-perfection-desktop@just-perfection \
		Lock-screen-background@xiaoguang_wang \
		start-overlay-in-application-view@hex_cz

install-font:
	@echo ====== install-font ======
	sudo apt install -y \
		font-manager \
		fonts-ancient-scripts \
		fonts-dejavu \
		fonts-droid-fallback \
		fonts-inconsolata \
		fonts-liberation \
		fonts-ubuntu
	$(MAKE) install-font-${DIST}-${VERSION}

install-font-ubuntu-noble install-font-ubuntu-resolute:
	sudo apt update
	sudo apt install -y \
		fonts-ubuntu-console

install-font-debian-trixie install-font-debian-bookworm: ;

install-gnome-app:
	@echo ====== install-gnome-app ======
	sudo apt update
	sudo apt install -y \
		eog \
		evince \
		gnome-calculator \
		gnome-logs \
		gnome-screenshot \
		gnome-terminal \
		gnome-tweaks \
		krita \
		nautilus \
		obs-studio \
		synaptic
	$(MAKE) install-gnome-app-${DIST}-${VERSION}

install-gnome-app-debian-trixie install-gnome-app-debian-bookworm: ;

install-gnome-app-ubuntu-noble install-gnome-app-ubuntu-resolute: ;

install-browser-chrome:
	@echo ====== install-browser-chrome ======
	curl -fsSL https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o /tmp/google-chrome-stable_current_amd64.deb
	sudo dpkg -i /tmp/google-chrome-stable_current_amd64.deb
	sudo apt -f -y install

install-browser-brave:
	@echo ====== install-browser-brave ======
	curl -fsS https://dl.brave.com/install.sh | sh

install-browser-firefox:
	@echo ====== install-browser-firefox ======
	agy -p "install firefox" --dangerously-skip-permissions

install-app-dbgate:
	@echo ====== install-app-dbgate ======
	curl -fsSL -o /tmp/dbgate.deb https://github.com/dbgate/dbgate/releases/latest/download/dbgate-latest.deb
	sudo dpkg -i /tmp/dbgate.deb
	sudo apt -f -y install

install-app-rambox:
	@echo ====== install-app-rambox ======
	curl -sSL "https://rambox.app/api/download?os=linux&package=deb" --output /tmp/rambox.deb
	sudo dpkg -i /tmp/rambox.deb
	sudo apt -f -y install

install-app-stacer:
	@echo ====== install-app-stacer ======
	curl -fsSL -o /tmp/stacer_1.1.0_amd64.deb https://github.com/oguzhaninan/Stacer/releases/download/v1.1.0/stacer_1.1.0_amd64.deb
	sudo dpkg -i /tmp/stacer_1.1.0_amd64.deb
	sudo apt -f -y install

install-app-virtualbox:
	@echo ====== install-app-virtualbox ======
	sudo apt update
	sudo apt install -y dkms
	$(MAKE) install-app-virtualbox-${DIST}-${VERSION}

install-app-virtualbox-debian-trixie:
	sudo apt update
	sudo apt install -y linux-headers-amd64
	sudo apt install -y libqt6core6t64 libqt6widgets6 libqt6gui6 libqt6dbus6 libqt6help6 libqt6printsupport6 libqt6statemachine6 libqt6xml6
	curl -fsSL -o /tmp/virtualbox.deb https://download.virtualbox.org/virtualbox/7.2.16/virtualbox-7.2_7.2.16-174877~Debian~trixie_amd64.deb
	sudo dpkg -i /tmp/virtualbox.deb
	sudo apt -f -y install

install-app-virtualbox-debian-bookworm:
	sudo apt update
	sudo apt install -y linux-headers-amd64
	curl -fsSL -o /tmp/virtualbox.deb https://download.virtualbox.org/virtualbox/7.2.16/virtualbox-7.2_7.2.16-174877~Debian~bookworm_amd64.deb
	sudo dpkg -i /tmp/virtualbox.deb
	sudo apt -f -y install

install-app-virtualbox-ubuntu-noble:
	sudo apt update
	sudo apt install -y linux-headers-generic
	sudo apt install libqt6core6t64 libqt6widgets6 libqt6gui6 libqt6dbus6 libqt6help6 libqt6printsupport6 libqt6statemachine6 libqt6xml6
	curl -fsSL -o /tmp/virtualbox.deb https://download.virtualbox.org/virtualbox/7.2.16/virtualbox-7.2_7.2.16-174877~Ubuntu~noble_amd64.deb
	sudo dpkg -i /tmp/virtualbox.deb
	sudo apt -f -y install

install-app-virtualbox-ubuntu-resolute:
	sudo apt update
	sudo apt install -y linux-headers-generic
	sudo apt install libqt6core6 libqt6widgets6 libqt6gui6 libqt6dbus6 libqt6help6 libqt6printsupport6 libqt6statemachine6 libqt6xml6
	curl -fsSL -o /tmp/virtualbox.deb https://download.virtualbox.org/virtualbox/7.2.16/virtualbox-7.2_7.2.16-174877~Ubuntu~resolute_amd64.deb
	sudo dpkg -i /tmp/virtualbox.deb
	sudo apt -f -y install

install-app-vlc:
	@echo ====== install-app-vlc ======
	sudo apt update
	sudo apt install -y vlc

install-app-vscode:
	@echo ====== install-app-vscode ======
	curl -fsSL -o /tmp/vscode.deb "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
	sudo dpkg -i /tmp/vscode.deb
	sudo apt -f -y install
	$(MAKE) install-vscode-ext

install-vscode-ext-all:
	code --install-extension EditorConfig.EditorConfig
	code --install-extension ctf0.macros
	code --install-extension ms-vscode-remote.remote-containers
	code --install-extension ms-vsliveshare.vsliveshare
	code --install-extension oderwat.indent-rainbow
	code --install-extension PKief.material-icon-theme
	code --install-extension redhat.vscode-yaml
	code --install-extension yatki.vscode-surround
	code --install-extension hashicorp.terraform

install-vscode-ext-node:
	code --install-extension chakrounanas.turbo-console-log
	code --install-extension dbaeumer.vscode-eslint
	code --install-extension oxc.oxc-vscode

install-vscode-ext-python:
	code --install-extension charliermarsh.ruff
	code --install-extension ms-python.python
	code --install-extension ms-python.vscode-pylance

install-vscode-ext-gh:
	code --install-extension GitHub.remotehub
	code --install-extension GitHub.vscode-github-actions
	code --install-extension github.vscode-pull-request-github

install-vscode-ext-ai:
	code --install-extension ms-vscode.vscode-speech
	code --install-extension ms-vscode.vscode-speech-language-pack-fr-fr

install-app-vscode-insiders:
	@echo ====== install-insiders ======
	curl -fsSL -o /tmp/vscode-insiders.deb "https://code.visualstudio.com/sha/download?build=insider&os=linux-deb-x64"
	sudo dpkg -i /tmp/vscode-insiders.deb
	sudo apt -f -y install
	$(MAKE) install-vscode-insiders-ext

install-vscode-insiders-ext-all:
	code-insiders --install-extension foam.foam-vscode
	code-insiders --install-extension mushan.vscode-paste-image
	code-insiders --install-extension PKief.material-icon-theme

install-app-insync:
	@echo ====== install-app-insync ======
	$(MAKE) install-app-insync-${DIST}-${VERSION}

install-app-insync-debian-trixie:
	curl -fsSL -o /tmp/insync.deb https://cdn.insynchq.com/builds/linux/3.9.11.60043/insync_3.9.11.60043-trixie_amd64.deb
	sudo dpkg -i /tmp/insync.deb
	sudo apt -f -y install

install-app-insync-debian-bookworm:
	curl -fsSL -o /tmp/insync.deb https://cdn.insynchq.com/builds/linux/3.9.11.60043/insync_3.9.11.60043-bookworm_amd64.deb
	sudo dpkg -i /tmp/insync.deb
	sudo apt -f -y install

install-app-insync-ubuntu-noble:
	curl -fsSL -o /tmp/insync.deb https://cdn.insynchq.com/builds/linux/3.9.11.60043/insync_3.9.11.60043-noble_amd64.deb
	sudo dpkg -i /tmp/insync.deb
	sudo apt -f -y install

install-app-insync-ubuntu-resolute:
	curl -fsSL -o /tmp/insync.deb https://cdn.insynchq.com/builds/linux/3.9.11.60043/insync_3.9.11.60043-resolute_amd64.deb
	sudo dpkg -i /tmp/insync.deb
	sudo apt -f -y install

install-app-yaak:
	@echo ====== install-app-yaak ======
	curl -fsSL -o ${HOME}/app/yaak.AppImage https://yaak.app/releases/v2026.7.1/linux-x86_64/yaak_2026.7.1_amd64.AppImage
	chmod a+x ${HOME}/app/yaak.AppImage

###### configure ######

configure-mise:
	@echo ====== configure-mise ======
	mkdir -p ${HOME}/.config/mise/
	ln -sf ${HOME}/.dotfiles/mise/mise.toml ${HOME}/.config/mise/config.toml

configure-locale: configure-locale-${DIST}-${VERSION}

configure-locale-debian-trixie configure-locale-debian-bookworm:
	@echo ====== configure-locale ======
	sudo sed -i '/^# *en_US.UTF-8 UTF-8/s/^# *//' /etc/locale.gen
	sudo sed -i '/^# *fr_FR.UTF-8 UTF-8/s/^# *//' /etc/locale.gen

	sudo locale-gen

	sudo update-locale LANG=en_US.UTF-8

	mise set -g LANG=en_US.UTF-8
	mise set -g LANGUAGE=en_US.UTF-8
	mise set -g LC_ALL=fr_FR.UTF-8

configure-locale-ubuntu-noble configure-locale-ubuntu-resolute:
	@echo ====== configure-locale ======
	sudo locale-gen en_US.UTF-8
	sudo locale-gen fr_FR.UTF-8

	sudo update-locale LANG=en_US.UTF-8

	mise set -g LANG=en_US.UTF-8
	mise set -g LANGUAGE=en_US.UTF-8
	mise set -g LC_ALL=fr_FR.UTF-8

configure-zsh:
	ln -sf ${HOME}/.dotfiles/zsh/.zprofile ${HOME}/.zprofile
	ln -sf ${HOME}/.dotfiles/zsh/.zshrc ${HOME}/.zshrc
	yes | cp -rf ${HOME}/.dotfiles/zsh/zsh-git-prompt.sh ${HOME}/.zsh/zsh-git-prompt/zshrc.sh
	yes | cp -rf ${HOME}/.dotfiles/zsh/gitstatus.py ${HOME}/.zsh/zsh-git-prompt/gitstatus.py

###### clean ######

clean-apt:
	@echo ====== clean-apt ======
	sudo apt autoremove --purge -y
	sudo apt autoclean -y
	sudo apt clean -y

clean-docker:
	@echo ====== clean-docker ======
	docker system prune -f

clean-log:
	@echo ====== clean-log ======
	sudo journalctl --vacuum-time=32d

clean-mise:
	@echo ====== clean-mise ======
	mise cache clean

clean-pkg-node:
	@echo ====== clean-pkg-node ======
	npm cache clean --force
	pnpm store prune

clean-pkg-python:
	@echo ====== clean-pkg-python ======
	pip cache purge

###### purge ######

purge-mise:
	mise prune -y
