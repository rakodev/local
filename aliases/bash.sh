#!/usr/bin/env bash

# https://stackoverflow.com/questions/1550288/os-x-terminal-colors
# https://geoff.greer.fm/lscolors/
# CLICOLOR=1 simply enables coloring of your terminal.
export CLICOLOR=1
# LSCOLORS=... specifies how to color specific items.
export LSCOLORS=ExfxcxdxBxegedabagacad

# https://unix.stackexchange.com/questions/166260/map-return-with-no-other-input-to-an-alias/166266#166266
# execute ll when press enter on empty terminal command
accept-line() {: "${BUFFER:="ll"}"; zle ".$WIDGET"}
zle -N accept-line

alias sc="source $HOME/.zshrc"
alias ls='ls -la'
alias c='clear'