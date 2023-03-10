# Python

## Install Python

### Pyenv

> pyenv lets you easily switch between multiple versions of Python.

- [Installation on Mac](https://github.com/pyenv/pyenv#installation)

- [Installation on Windows](https://github.com/pyenv-win/pyenv-win/blob/master/docs/installation.md#git-commands)

- To list all available Python versions  
```pyenv install -l```
- Install one  
```pyenv install 3.11.2```
- Show all installed version  
```pyenv versions```
- Show selected version  
```pyenv version```
- Select one  
```pyenv global 3.11.2```

## Dependency Manager

There are 2 main options:

- [pip](https://pip.pypa.io/en/stable/cli/)

> pip is the package installer for Python.

- [pipenv](https://pipenv.pypa.io/en/latest/#install-pipenv-today)

> It is intended to replace **$ pip install** usage, as well as manual virtualenv management.  
> Pipenv automatically creates and manages a virtualenv for your projects, as well as adds/removes packages from your Pipfile as you install/uninstall packages.

### Pip

To create a requirements.txt file for you project after installing libraries with pip

```shell
pip freeze > requirements.txt
```

Install from requirements.txt

```shell
pip install -r requirements.txt
```

### Pipenv

Install Pipenv

```shell
pip install pipenv
```