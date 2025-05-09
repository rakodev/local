#!/bin/bash

# MacOS tools Installation

# List of tools to install with Homebrew
BREW_TOOLS=("nodemon" "tfenv" "jq" "coreutils" "fzf" "ffmpeg" "pyenv" "terragrunt" "stats" "visual-studio-code" "docker" "awscli")

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

# Explanation:
# 	•	FZF_INSTALL_KEYBINDINGS=1: enables key bindings (like Ctrl+R)
# 	•	FZF_INSTALL_COMPLETION=1: enables shell completion
# 	•	FZF_INSTALL_UPDATE_RC=1: updates your .zshrc
# 	•	--no-bash, --no-fish: skip config for other shells
# https://github.com/junegunn/fzf?tab=readme-ov-file#setting-up-shell-integration
export FZF_INSTALL_KEYBINDINGS=1
export FZF_INSTALL_COMPLETION=1
export FZF_INSTALL_UPDATE_RC=1
yes | /opt/homebrew/opt/fzf/install --no-bash --no-fish


# # Install zsh-autosuggestions
# git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# # Add zsh-autosuggestions to plugins if not already added
# if ! grep -q 'zsh-autosuggestions' ~/.zshrc; then
#     sed -i '' 's/plugins=(git)/plugins=(git zsh-autosuggestions)/' ~/.zshrc
# fi

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

# Set up git difftool and mergetool to use Visual Studio Code
git config --global merge.tool vscode
git config --global mergetool.vscode.cmd "code --wait \$MERGED"
git config --global mergetool.prompt false

# Restart zsh to apply changes
exec zsh

echo "Initial setup completed successfully!"