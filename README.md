# dotfiles

> personal dotfiles

## dependencies
 - curl
 - git
 - make

## guidelines
- if it need config, at a section into makefile
    - if not, just append to the list (apt or else)

## usage
export DIST=debian
export VERSION=trixie
clone 
? make swap
make install
make install [dist=...] [version=...]


make install essential (even if not preseed)
    ca fait install + config
    install de quoi ? 
        curl git make ?
        curl git make gnome-shell ?
make install desktop

=> decision, on fait un environement graphique uniquement ! 
donc pas de split cli/apps
essential = curl git make gnome-shell
seed = timedate, local, user,... (comme ci on avait pas preseed) c'est le setup


# TODO
- faire 1 container par distrib-version pour tester en local que tout marche bien
- ne pas faire de vm (trop gourmand) mais un container romainprignon/dotfiles:ubuntu-jammy romainprignon/dotfiles:debian-trixie
- lien symbolink vers /etc/apt/source.list
- python 3 en dependency et pyinfra ?
