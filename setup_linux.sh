#!/bin/bash

function installPackage {
    PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $1|grep "install ok installed")
    if [ "" == "$PKG_OK" ]; then
      echo "No $1. Setting up $1."
      sudo apt-get --force-yes --yes install $1
    fi
}

function addRepository {
    sudo add-apt-repository -y $1
    sudo apt-get update
}

function installDotfiles {
    tar zxvf $1 -C ~/
    rm $1
}

# Add necessary repositories
addRepository "ppa:cassou/emacs"

# Install base packages
installPackage "wget"
installPackage "curl"
installPackage "vim"
installPackage "emacs-snapshot"

# Extract and install dotfiles
installDotfiles "pip.tar.gz"
installDotfiles "nvm.tar.gz"
installDotfiles "virtualenvs.tar.gz"
installDotfiles "dotfiles.tar.gz"

ln -sf ~/.dotfiles/.bash_profile ~/
ln -sf ~/.dotfiles/.bashrc ~/
ln -sf ~/.dotfiles/.bashrc_custom ~/
ln -sf ~/.dotfiles/.profile ~/
ln -sf ~/.dotfiles/.screenrc ~/
ln -sf ~/.dotfiles/.emacs.d ~/

# Install SGI font for Terminal
tar zxvf sgi.tgz
rm sgi/Scr15.pcf
sudo mv sgi /usr/share/fonts/

sudo rm /etc/fonts/conf.d/70-no-bitmaps.conf
sudo ln -s /etc/fonts/conf.avail/70-force-bitmaps.conf /etc/fonts/conf.d
sudo fc-cache -fv

