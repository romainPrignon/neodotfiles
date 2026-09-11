ARG dist
ARG version
FROM $dist:$version

ARG user=romainprignon
ARG password=romainprignon

# buildtime deps
RUN apt update && apt install -y \
    openssl \
    sudo

# runtime deps
RUN apt update && apt install -y \
    curl \
    git \
    make

RUN useradd --create-home --password $(echo "$password" | openssl passwd -1 -stdin) --shell /bin/bash $user
RUN usermod -aG sudo $user

USER $user

RUN mkdir -p /home/$user/.dotfiles
WORKDIR /home/$user/.dotfiles

COPY --chown=$user:$user . .

CMD ["bash"]
