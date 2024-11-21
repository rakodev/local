#!/bin/bash

# MacOS tools Installation

# List of tools to install with Homebrew
BREW_TOOLS=("nodemon" "tfenv" "jq" "coreutils" "fzf" "ffmpeg" "pyenv")

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Install Homebrew if not already installed
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Add Homebrew to PATH if not already added
if ! grep -q '/opt/homebrew/bin' ~/.zshrc; then
    echo 'export PATH="/opt/homebrew/bin:$PATH"' >> ~/.zshrc
fi

# Install essential tools if not already installed
for tool in "${BREW_TOOLS[@]}"; do
    if ! brew list -1 | grep -q "^${tool}\$"; then
        brew install $tool
    fi
done

# Install Oh My Zsh if not already installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Add pyenv to PATH and initialize it if not already added
if ! grep -q 'pyenv init' ~/.zshrc; then
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
    echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
    echo 'eval "$(pyenv init --path)"' >> ~/.zshrc
    echo 'eval "$(pyenv init -)"' >> ~/.zshrc
fi

# Reload zsh configuration
source ~/.zshrc

# Install the latest Python version with pyenv and set it as global if not already installed
latest_python=$(pyenv install --list | grep -v - | grep -v b | grep -E '^\s*[0-9]+\.[0-9]+\.[0-9]+\s*$' | tail -1)
if ! pyenv versions | grep -q "$latest_python"; then
    pyenv install -s $latest_python
    pyenv global $latest_python
fi

# Remove last login message from terminal
touch ~/.hushlogin

# Load aliases and settings if not already added
if ! grep -q 'for file in ~/local/aliases/*' ~/.zshrc; then
    echo 'for file in ~/local/aliases/*; do source "$file"; done' >> ~/.zshrc
fi
if ! grep -q 'source ~/local/settings/vimrc' ~/.vimrc; then
    echo "source ~/local/settings/vimrc" >> ~/.vimrc
fi

# Enable global gitignore file
git config --global core.excludesfile ~/local/utils/global.gitignore

# Git pull without creating a merge commit (fast-forward)
git config --global pull.ff true

# Restart zsh to apply changes
exec zsh

echo "Initial setup completed successfully!"