#!/bin/bash

# MacOs tools Installation

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Add brew to path
echo -n 'export PATH=/opt/homebrew/bin:$PATH' >> ~/.zshrc

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Choose zsh as default shell
chsh -s /bin/zsh

# Install zsh-autosuggestions
brew install zsh-autosuggestions

# Enable zsh-autosuggestions
echo "source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc

# Remove last login message from terminal
touch ~/.hushlogin

# Load my aliases
echo 'for file in ~/local/aliases/*; do' >> ~/.zshrc
echo '    source "$file"' >> ~/.zshrc
echo 'done' >> ~/.zshrc
# Set Vim settings
echo "source ~/local/settings/vimrc" > ~/.vimrc

# Enable global gitignore file
git config --global core.excludesfile ~/local/utils/global.gitignore

# Git pull without creating a merge commit (fast-forward)
git config --global pull.ff true
# Configure Git to only allow fast-forward pushes by default
git config --global push.ff only

# Source zshrc
source ~/.zshrc

# Install Clipy
brew install --cask clipy

# Install Visual Studio Code
brew install --cask visual-studio-code

# Install Docker
brew install --cask docker

# Install Rectangle
brew install --cask rectangle

# Install Aws Cli
brew install awscli

# Install Node
brew install node

# Install Nodemon globally
npm install -g nodemon

# Install Tfenv
brew install tfenv

# Install Jq
brew install jq

# Install Coreutils
brew install coreutils

# Install Tmux
brew install tmux

# Add these lines to ~/.tmux.conf
echo "set -g mouse on # Enable mouse support for switching panes/windows" >> ~/.tmux.conf
echo "set -g history-limit 10000 # Set history limit to 10000 lines" >> ~/.tmux.conf
tmux source-file ~/.tmux.conf

# Install fzf
brew install fzf

# Install ffmpeg
brew install ffmpeg

# Install PyEnv
brew install pyenv

# Add pyenv to path
echo -n 'export PATH="$HOME/.pyenv/bin:$PATH"' >> ~/.zshrc
# or try this:
# printf 'export PYENV_ROOT=/usr/local/opt/pyenv; export PATH="$PYENV_ROOT/bin:$PATH"\n' >> ~/.zshrc

echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
echo 'eval "$(pyenv init -)"' >> ~/.zshrc

# Install latest python with pyenv and set it as global
pyenv install $(pyenv install --list | grep -v - | tail -1)
pyenv global $(pyenv versions --bare | grep -v - | tail -1)

python -m pip install boto3
