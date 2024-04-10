#!/bin/bash

# Alias to use Copilot suggest with generic shell command response
alias gc-suggest='copilot_suggest'
alias gc-explain='copilot_explain'

# Function to use Copilot suggest in CLI
copilot_suggest() {
    # Check if Copilot command exists
    if command -v gh &> /dev/null; then
        # Run Copilot suggest command with the provided argument
        gh copilot suggest "$@"
    else
        echo "gh Copilot command not found."
        # Check github page for installation
        echo "See: https://github.com/github/gh-copilot"
    fi
}

copilot_explain() {
    # Check if Copilot command exists
    if command -v gh &> /dev/null; then
        # Run Copilot suggest command with the provided argument
        gh copilot explain "$@"
    else
        echo "gh Copilot command not found."
        # Check github page for installation
        echo "See: https://github.com/github/gh-copilot"
    fi
}

