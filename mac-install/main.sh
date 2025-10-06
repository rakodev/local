#!/bin/bash

set -euo pipefail

GREEN="\033[32m"; YELLOW="\033[33m"; BLUE="\033[34m"; RED="\033[31m"; DIM="\033[2m"; RESET="\033[0m"
log() { printf "%b[%s]%b %s\n" "$BLUE" "$1" "$RESET" "$2"; }
ok()  { printf "%b[OK]%b %s\n"   "$GREEN" "$RESET" "$1"; }
warn(){ printf "%b[WARN]%b %s\n" "$YELLOW" "$RESET" "$1"; }
err() { printf "%b[ERR]%b %s\n"  "$RED" "$RESET" "$1"; }
skip(){ printf "%b[SKIP]%b %s%b\n" "$DIM" "$RESET" "$1" "$RESET"; }

# Notes:
#  - We set strict mode so the script stops on the first failing command instead of
#    spamming "brew: command not found" for every tool.
#  - We explicitly eval Homebrew's shellenv after installation so brew is available
#    in this running (non-login) shell.

# MacOS tools Installation

# List of Homebrew formulae (CLI / libraries)
FORMULA_TOOLS=(
    "tfenv" "jq" "coreutils" "fzf" "ffmpeg" "pyenv" "awscli" "pre-commit" "imagemagick" 
    "openjdk" "ruby" "go" "watchman" "node"
)

# List of Homebrew casks (GUI / apps / binaries distributed as bundles)
CASK_TOOLS=(
    "visual-studio-code" "docker" "discord" "rectangle" "warp" "react-native-debugger" "zulu" "bitwarden"
)

# (Optional) Paid apps – uncomment if you own licenses
# CASK_TOOLS+=("istat-menus")
# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

HOMEBREW_PREFIX="/opt/homebrew"  # Apple Silicon default
if [[ "$(uname -m)" != "arm64" ]]; then
    # Intel fallback
    HOMEBREW_PREFIX="/usr/local"
fi

# Install Homebrew if not already installed
if ! command -v brew >/dev/null 2>&1; then
    log INFO "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Ensure brew is on PATH for this current script run (not just future shells)
if [[ -x "${HOMEBREW_PREFIX}/bin/brew" ]]; then
    eval "$(${HOMEBREW_PREFIX}/bin/brew shellenv)"
fi

if ! command -v brew >/dev/null 2>&1; then
    err "Homebrew installed but 'brew' still not in PATH"
    warn "Run: eval \"$(${HOMEBREW_PREFIX}/bin/brew shellenv)\" then re-run script"
    exit 1
fi

# Persist Homebrew PATH (use .zprofile so login shells pick it up; keep idempotent)
if ! grep -q 'brew shellenv' ~/.zprofile 2>/dev/null; then
    log INFO "Persisting brew shellenv in ~/.zprofile"
    echo "eval \"$(${HOMEBREW_PREFIX}/bin/brew shellenv)\"" >> ~/.zprofile
else
    skip "brew shellenv already in ~/.zprofile"
fi

# Also add a defensive export in .zshrc if user opens non-login interactive shells
if ! grep -q "${HOMEBREW_PREFIX}/bin" ~/.zshrc 2>/dev/null; then
    log INFO "Adding fallback PATH export to ~/.zshrc"
    echo "export PATH=\"${HOMEBREW_PREFIX}/bin:$PATH\"" >> ~/.zshrc
else
    skip "PATH entry already in ~/.zshrc"
fi

# Install formulae (skip if already present)
for tool in "${FORMULA_TOOLS[@]}"; do
    if brew ls --versions "$tool" >/dev/null 2>&1; then
        skip "Formula already installed: $tool"
        continue
    fi
    log FORMULA "Installing $tool"
    if brew install "$tool" >/dev/null; then
        ok "Installed formula: $tool"
    else
        warn "Failed to install formula $tool"
    fi
done

# Install casks (skip if already present)
for cask in "${CASK_TOOLS[@]}"; do
    if brew list --cask "$cask" >/dev/null 2>&1; then
        skip "Cask already installed: $cask"
        continue
    fi
    log CASK "Installing $cask"
    if brew install --cask "$cask" >/dev/null; then
        ok "Installed cask: $cask"
    else
        warn "Failed to install cask $cask"
    fi
done

# Install global npm utilities (after node installed)
if command -v npm >/dev/null 2>&1; then
    if ! command -v nodemon >/dev/null 2>&1; then
        log NPM "Installing global nodemon"
        if npm install -g nodemon >/dev/null 2>&1; then
            ok "Installed nodemon"
        else
            warn "Failed to install nodemon globally"
        fi
    else
        skip "Global nodemon already present"
    fi
else
    warn "npm not found; skipping global nodemon"
fi

# Install Oh My Zsh if not already installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    log OHMYZSH "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Add pyenv to PATH and initialize it if not already added
if ! grep -q 'pyenv init' ~/.zshrc; then
    log PYENV "Configuring pyenv in ~/.zshrc"
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
    echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
    echo 'eval "$(pyenv init --path)"' >> ~/.zshrc
    echo 'eval "$(pyenv init -)"' >> ~/.zshrc
else
    skip "pyenv init already present in ~/.zshrc"
fi

if ! grep -q '/opt/homebrew/opt/openjdk/bin' ~/.zshrc; then
    log PATH "Adding OpenJDK bin path"
    echo 'export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"' >> ~/.zshrc
else
    skip "OpenJDK path already in ~/.zshrc"
fi
if ! grep -q 'Library/Android/sdk/platform-tools' ~/.zshrc; then
    log PATH "Adding Android platform-tools to PATH"
    echo 'export PATH=$PATH:$HOME/Library/Android/sdk/platform-tools' >> ~/.zshrc
else
    skip "Android platform-tools already in PATH"
fi
if ! grep -q 'JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-24.jdk/Contents/Home/' ~/.zshrc; then
    log PATH "Setting JAVA_HOME for Zulu JDK"
    echo 'export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-24.jdk/Contents/Home/' >> ~/.zshrc
else
    skip "JAVA_HOME already set for Zulu JDK"
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
if [[ -x "${HOMEBREW_PREFIX}/opt/fzf/install" ]]; then
    if grep -q '\[ -f ~/.fzf.zsh \] && source ~/.fzf.zsh' ~/.zshrc 2>/dev/null && [[ -f "$HOME/.fzf.zsh" ]]; then
        skip "fzf shell integration already configured"
    else
        log FZF "Running fzf install script"
        yes | "${HOMEBREW_PREFIX}/opt/fzf/install" --no-bash --no-fish >/dev/null
    fi
fi


# # Install zsh-autosuggestions
# git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# # Add zsh-autosuggestions to plugins if not already added
# if ! grep -q 'zsh-autosuggestions' ~/.zshrc; then
#     sed -i '' 's/plugins=(git)/plugins=(git zsh-autosuggestions)/' ~/.zshrc
# fi

# NOTE: Do NOT source ~/.zshrc here.
# This script runs under bash (shebang #!/bin/bash). Sourcing a zsh-oriented
# config that loads Oh My Zsh triggers unbound variable errors under 'set -u'
# because variables like ZSH_VERSION are referenced before definition in bash.
# We only needed the appended lines for future zsh sessions; brew and pyenv
# binaries are already on PATH in this process via 'brew shellenv'.
# If you really need to evaluate a zsh environment mid-script, use:
#   zsh -ic 'command'
# but it's unnecessary for current steps, so we skip sourcing.

# Install the latest stable CPython patch version via pyenv
# We normalize whitespace, exclude prereleases (a, b, rc), and sort versions properly.
latest_python=$(pyenv install --list \
    | sed 's/^[[:space:]]*//' \
    | grep -E '^[0-9]+\.[0-9]+\.[0-9]+$' \
    | grep -v -E '(a|b|rc)' \
    | sort -V \
    | tail -1)

if [[ -z "${latest_python:-}" ]]; then
    warn "Could not determine latest Python version from pyenv list"
else
    if ! pyenv versions --bare | grep -qx "$latest_python"; then
        log PYENV "Installing Python ${latest_python}";
        if ! pyenv install -s "$latest_python" >/dev/null 2>&1; then
            warn "Initial install failed. Attempting to upgrade pyenv and retry."
            if command -v brew >/dev/null 2>&1; then
                brew upgrade pyenv >/dev/null 2>&1 || warn "brew upgrade pyenv failed"
                # Re-evaluate latest version after upgrade
                latest_python=$(pyenv install --list \
                    | sed 's/^[[:space:]]*//' \
                    | grep -E '^[0-9]+\.[0-9]+\.[0-9]+$' \
                    | grep -v -E '(a|b|rc)' \
                    | sort -V \
                    | tail -1)
                if ! pyenv install -s "$latest_python" >/dev/null 2>&1; then
                    warn "Still failed to install Python $latest_python; skipping"
                else
                    pyenv global "$latest_python"; ok "Python $latest_python installed and set global (after upgrade)"; fi
            else
                warn "brew not available to upgrade pyenv; skipping Python installation"
            fi
        else
            pyenv global "$latest_python"; ok "Python $latest_python installed and set global";
        fi
    else
        skip "Python $latest_python already installed"
    fi
fi

# Remove last login message from terminal
touch ~/.hushlogin

# Load aliases and settings if not already added
if ! grep -q 'for file in ~/local/aliases/*' ~/.zshrc; then
    log ALIASES "Adding aliases loader to ~/.zshrc"
    echo 'for file in ~/local/aliases/*; do source "$file"; done' >> ~/.zshrc
else
    skip "Aliases loader already present"
fi
if ! grep -q 'source ~/local/settings/vimrc' ~/.vimrc; then
    log VIM "Linking vimrc include"
    echo "source ~/local/settings/vimrc" >> ~/.vimrc
else
    skip "vimrc include already present"
fi

# Enable global gitignore file
git config --global core.excludesfile ~/local/utils/global.gitignore

# Git pull without creating a merge commit (fast-forward)
git config --global pull.ff true

# Set up git difftool and mergetool to use Visual Studio Code
git config --global merge.tool vscode
git config --global mergetool.vscode.cmd "code --wait \$MERGED"
git config --global mergetool.prompt false

# Configure screenshot location (must be before exec zsh)
log MACOS "Configuring screenshot location"
mkdir -p ~/Documents/Screenshots
if defaults write com.apple.screencapture location ~/Documents/Screenshots; then
    ok "Screenshot location set to ~/Documents/Screenshots"
    # Restart SystemUIServer to apply screenshot location change immediately
    killall SystemUIServer 2>/dev/null || warn "Could not restart SystemUIServer"
else
    warn "Could not set screenshot location"
fi

ok "Initial setup completed successfully!"

# Restart zsh to apply changes (must be last - replaces current process)
exec zsh
