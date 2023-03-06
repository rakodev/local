#!/bin/bash
export PYTHONDONTWRITEBYTECODE="ok"
export TK_SILENCE_DEPRECATION=1
alias python-pipenv-list='for venv in ~/.local/share/virtualenvs/* ; do basename $venv; cat $venv/.project | sed "s/\(.*\)/\t\1\n/" ; done'
