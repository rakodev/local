#!/bin/bash
export PYTHONDONTWRITEBYTECODE="ok"
export TK_SILENCE_DEPRECATION=1
# Pip
alias pip-freeze='pip freeze > requirements.txt'
alias pip-install-requirements='pip install -r requirements.txt'
# Pipenv
alias python-pipenv-list='for venv in ~/.local/share/virtualenvs/* ; do basename $venv; cat $venv/.project | sed "s/\(.*\)/\t\1\n/" ; done'
# Venv
alias venv-create='python -m venv .venv'
alias venv-activate='source .venv/bin/activate'
alias venv-activate-windows='source .venv/Scripts/activate'
alias venv-deactivate='deactivate'
# Virtualenv venv
alias virtualenv-create='virtualenv .venv'
alias virtualenv-activate='source .venv/bin/activate'
alias virtualenv-deactivate='deactivate'
alias virtualenv-delete-env='rmvirtualenv .venv'
