#!/bin/sh

XDG_DATA_HOME=${XDG_DATA_HOME:="$HOME/.local/share"}
XDG_CACHE_HOME=${XDG_CACHE_HOME:="$HOME/.cache"}
XDG_CONFIG_HOME=${XDG_CONFIG_HOME:="$HOME/.config"}

MY_PATH=$(pwd)

# zsh
if [ "$SHELL" != "/usr/bin/zsh" ]; then
  # Install zsh
  echo "Installing zsh"
  sudo apt-get -y install zsh
  mkdir -p "$XDG_CACHE_HOME"/zsh
  touch "$XDG_CACHE_HOME"/zsh/history
  # Set zsh config location
  # shellcheck disable=SC2016
  grep -qxF 'export ZDOTDIR="$HOME/.config/zsh/"' /etc/zsh/zshenv || echo 'export ZDOTDIR="$HOME/.config/zsh/"' | sudo tee -a /etc/zsh/zshenv
  # set default shell
  chsh -s "$(which zsh)"
  echo "Default shell changed to zsh"

  echo "Installing plugins"
  sudo apt install command-not-found # Installed in Ubuntu by default
  wget "https://github.com/MichaelAquilina/zsh-you-should-use/blob/master/you-should-use.plugin.zsh?raw=true" -O "$MY_PATH"/.config/zsh/plugins/you-should-use.plugin.zsh
  git clone --depth 1 https://github.com/romkatv/powerlevel10k.git "$MY_PATH"/.config/zsh/powerlevel10k
  git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git "$MY_PATH"/.config/zsh/zsh-syntax-highlighting
  git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions.git "$MY_PATH"/.config/zsh/zsh-autosuggestions
  echo ""

  echo "Re-login"
fi

# neofetch (https://github.com/dylanaraps/neofetch)
# Try git source install for recent releases
sudo apt-get -y install neofetch

# Fonts
if [ ! -f "$XDG_DATA_HOME"/fonts/Ubuntu\ Mono\ Nerd\ Font\ Complete\ Mono.ttf ]; then
  echo "Installing fonts"
  wget "https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/Hack/Bold/complete/Hack%20Bold%20Nerd%20Font%20Complete.ttf?raw=true" -O "$XDG_DATA_HOME"/fonts/Hack\ Bold\ Nerd\ Font\ Complete.ttf
  wget "https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/Hack/BoldItalic/complete/Hack%20Bold%20Italic%20Nerd%20Font%20Complete.ttf?raw=true" -O "$XDG_DATA_HOME"/fonts/Hack\ Bold\ Italic\ Nerd\ Font\ Complete.ttf
  wget "https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/Hack/Italic/complete/Hack%20Italic%20Nerd%20Font%20Complete.ttf?raw=true" -O "$XDG_DATA_HOME"/fonts/Hack\ Italic\ Nerd\ Font\ Complete.ttf
  wget "https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/Hack/Regular/complete/Hack%20Regular%20Nerd%20Font%20Complete.ttf?raw=true" -O "$XDG_DATA_HOME"/fonts/Hack\ Regular\ Nerd\ Font\ Complete.ttf
  wget "https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/UbuntuMono/Regular/complete/Ubuntu%20Mono%20Nerd%20Font%20Complete%20Mono.ttf?raw=true" -O "$XDG_DATA_HOME"/fonts/Ubuntu\ Mono\ Nerd\ Font\ Complete\ Mono.ttf
  fc-cache -f -v
  echo "Reopen the terminal and set Hack\ Regular\ Nerd\ Font\ Complete.ttf as your terminal font"
fi

if ! [ -x "$(command -v lf)" ]; then
  echo "Installing lf"
  if ! [ -x "$(command -v lf)" ]; then
    echo "Installing Golang"
    GO_VERSION=$(curl -sSL "https://golang.org/VERSION?m=text")
    GO_VERSION=${GO_VERSION#go}
    # subshell
    (
      kernel=$(uname -s | tr '[:upper:]' '[:lower:]')
      curl -sSL "https://storage.googleapis.com/golang/go${GO_VERSION}.${kernel}-amd64.tar.gz" | sudo tar -v -C /usr/local -xz
    )
    # Paths already added in env file
    echo ""
  fi
  env CGO_ENABLED=0 GO111MODULE=on go get -u -ldflags="-s -w" github.com/gokcehan/lf
fi

# link vimrc
ln -sf "$MY_PATH"/.config/nvim/init.vim "$HOME"/.vimrc

# bash
ln -sf "$XDG_CONFIG_HOME"/bash/.bash_profile "$HOME"/.bash_profile
ln -sf "$XDG_CONFIG_HOME"/bash/.bashrc "$HOME"/.bashrc
ln -sf "$XDG_CONFIG_HOME"/bash/.bash_logout "$HOME"/.bash_logout

# Neovim (New vim!)
sudo apt-get -y install neovim

# install tldr (help pages) python client https://github.com/tldr-pages/tldr-python-client
# sudo apt install -y python3-pip
# pip3 install tldr

# pyenv https://github.com/pyenv/pyenv
# git clone https://github.com/pyenv/pyenv.git "$XDG_DATA_HOME"/pyenv
# echo "uncomment pyenv path in $XDG_CONFIG_HOME/shell/envrc"

# sdkman (https://sdkman.io/install)
# curl -s "https://get.sdkman.io" | bash
# echo "uncomment sdkman path in $XDG_CONFIG_HOME/shell/envrc"

# Nodenv (https://github.com/nodenv/nodenv#installation)
# git clone https://github.com/nodenv/nodenv.git $XDG_DATA_HOME/nodenv
# cd $XDG_DATA_HOME/nodenv; src/configure && make -C src
# echo "uncomment Nodenv path in $XDG_CONFIG_HOME/shell/envrc"

# glow (markdown reader) https://github.com/charmbracelet/glow
# shellcheck disable=SC2015
git clone --depth 1 https://github.com/charmbracelet/glow.git /tmp/glow && cd /tmp/glow/ || {
  echo "Failed"
  exit 1
}
go build
cp glow "$GOPATH"/bin

# Highlight (formatted text converter)
sudo apt install -y highlight

# Zathura (document viewer)
sudo apt install -y zathura

# Newsboat (RSS/Atom feed reader)
sudo apt install -y newsboat

# sxiv (Image Viewer)
sudo apt install sxiv

# Gnome
# Auto-hide the Dock, Click to minimise
# gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize'
sudo apt install gnome-tweaks
# For things like ctrl key for pointer location
