#!/usr/bin/env bash
# 
# An opinionated bootstrap script for setting up a new OSX machine
# 
# This should be idempotent so it can be run multiple times.
#
#
# Notes:
#
# - If installing full Xcode, it's better to install that first from the app
#   store before running the bootstrap script. Otherwise, Homebrew can't access
#   the Xcode libraries as the agreement hasn't been accepted yet.

# Variables:
default=`tput sgr0`
primary=`tput setaf 2`
secondary=`tput setaf 4`
bold=`tput bold`
title=${primary}${bold}
subtitle=${secondary}${bold}
username=`whoami`

echo "${title}Starting MacOS Init${default}"

echo "${title}Installing Command Line Developer Tools${default}"
xcode-select --install

# Check for Homebrew, install if we don't have it
if test ! $(which brew); then
    echo "${title}Installing homebrew..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

	if [[ `uname -m` == 'arm64' ]]; then
  		echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "/Users/${username}/.zprofile"
  		eval "$(/opt/homebrew/bin/brew shellenv)"
	fi
fi

# Update homebrew recipes
echo "${title}Updating Homebrew...\n${default}"
brew update

# Install GNU core utilities (those that come with OS X are outdated)
echo "${title}Installing GNU core utilities...\n${default}"
brew install coreutils
brew install gnu-sed --with-default-names
brew install gnu-tar --with-default-names
brew install gnu-indent --with-default-names
brew install gnu-which --with-default-names
brew install gnu-grep --with-default-names

# Install GNU Utils
echo "${title}Installing GNU findutils...\n${default}"
brew install findutils


# Install Dev Tools
echo "${title}Installing Dev Tools...\n${default}"

echo "${subtitle}Configuring zsh...${default}"
echo "${bold}- Changing shell to zsh...${default}"
chsh -s /bin/zsh


echo "${bold}- Installing oh-my-zsh...${default}"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended


echo "${subtitle}Installing git...${default}"
brew install git


# Git Config
echo "${subtitle}Configuring Git...${default}"

read -p "Enter Your Name: " name
git config --global user.name "${name}"

read -p "Enter Your Email: " email
git config --global user.email ${email}

read -p "Enter Your Git Username: " username
git config --global github.user ${username}


# Git Aliases

git config --global alias.graph log --graph --date-order -C -M --pretty=format:\"<%h> %ad [%an] %Cgreen%d%Creset %s\" --all --date=short
git config --global alias.lg log --graph --pretty=format:'%Cred%h%Creset %C(yellow)%an%d%Creset %s %Cgreen(%cr)%Creset' --date=relative
git config --global alias.ls log --pretty=format:"%C(yellow)%h%Cred%d\\ %Creset%s%Cgreen\\ [%cn]" --decorate
git config --global alias.ll log --pretty=format:"%C(yellow)%h%Cred%d\\ %Creset%s%Cgreen\\ [%cn]" --decorate --numstat
git config --global alias.fl log -u
git config --global alias.f "!git ls-files | grep -i"
git config --global alias.cp cherry-pick
git config --global alias.st status -s
git config --global alias.cl clone
git config --global alias.ci commit
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.dc diff --cached


echo "${subtitle}Installing nvm...${default}"
if [[ ! -e ~/.zshrc ]]; then
    touch ~/.zshrc
fi

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

nvm install node

echo "${subtitle}Installing global npm packages...${default}"

echo "${bold}- Installing typescript...${default}"
npm install -g typescript

echo "${bold}- Installing prettier...${default}"
npm install -g prettier

echo "${bold}- Installing eslint...${default}"
npm install -g eslint

echo "${bold}- Installing expo-cli...${default}"
npm install -g expo-cli

echo "${bold}- Installing eas-cli...${default}"
npm install -g eas-cli

echo "${subtitle}Installing watchman...${default}"
brew install watchman

echo "${subtitle}Installing yarn...${default}"
brew install yarn

echo "${subtitle}Installing Python...${default}"
brew install pyenv
pyenv install-latest

echo "${subtitle}Installing VS Code...${default}"
brew install --cask visual-studio-code

echo "${subtitle}Installing Android Studio...${default}"
brew install --cask android-studio

echo "${subtitle}Installing Postman...${default}"
brew install --cask postman

echo "${subtitle}Installing Docker...${default}"
brew install docker

#Install Browsers

echo "${title}Installing Browsers...\n${default}"

echo "${subtitle}Installing Arc...${default}"
brew install --cask arc

echo "${subtitle}Installing Firefox...${default}"
brew install --cask firefox

echo "${subtitle}Installing Google Chrome...${default}"
brew install --cask google-chrome

#Install Communications

echo "${title}Installing Communications...\n${default}"

echo "${subtitle}Installing Slack...${default}"
brew install --cask slack

echo "${subtitle}Installing Telegram...${default}"
brew install --cask telegram

echo "${subtitle}Installing Discord...${default}"
brew install --cask discord

# Install Entertainment

echo "${title}Installing Entertainment...\n${default}"

echo "${subtitle}Installing VLC...${default}"
brew install --cask vlc

# Install Utilities

echo "${title}Installing Utilities...\n${default}"

echo "${subtitle}Installing wget...${default}"
brew install wget

echo "${subtitle}Installing z...${default}"
brew install z

echo "${subtitle}Installing ag...${default}"
brew install ag

echo "${subtitle}Installing ack...${default}"
brew install ack

echo "${subtitle}Installing fd...${default}"
brew install fd

echo "${subtitle}Installing ffind...${default}"
brew install ffind

echo "${subtitle}Installing fpp...${default}"
brew install fpp

echo "${subtitle}Installing GPG Suite...${default}"
brew install --cask gpg-suite

echo "${subtitle}Installing Figma...${default}"
brew install --cask figma

echo "${subtitle}Installing Notion...${default}"
brew install --cask notion

echo "${subtitle}Installing Linear...${default}"
brew install --cask linear

echo "${subtitle}Installing 1Password...${default}"
brew install --cask 1password

echo "${subtitle}Installing The Unarchiver...${default}"
brew install --cask the-unarchiver

echo "${subtitle}Installing Debookee...${default}"
brew install --cask debookee

echo "${subtitle}Installing Handbrake...${default}"
brew install --cask handbrake

echo "${subtitle}Installing TeamViewer...${default}"
brew install --cask teamviewer

echo "${subtitle}Installing Raycast...${default}"
brew install --cask raycast

echo "${title}Installing fonts...${default}"

brew tap homebrew/cask-fonts

brew install svn

echo "${subtitle}Installing Hack Font...${default}"
brew install font-hack

echo "${subtitle}Installing Inconsolidata Font...${default}"
brew install font-inconsolidata

echo "${subtitle}Installing Roboto Font...${default}"
brew install font-roboto

echo "${subtitle}Installing Clear Sans Font...${default}"
brew install font-clear-sans

echo "${title}Installing Ruby gems...\n${default}"

echo "${subtitle}Installing Cocoapods...${default}"
sudo gem install cocoapods


echo "Configuring OSX..."

# Set fast key repeat rate
defaults write NSGlobalDomain KeyRepeat -int 0

# Require password as soon as screensaver or sleep mode starts
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Show filename extensions by default
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Enable tap-to-click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1


echo "Cleaning up..."
brew cleanup

echo "MacOS Init complete"
