# Local best practices

## This repo is a way to create alias for your Terminal and it can also be used as a reminder for some commands you don't use often

### Set your global git name and email

```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
```

### Set your git name and email for a single repository

```bash
git config user.name "Your Name"
git config user.email "email@example.com"
```

### Clone this repository

```bash
cd ~
git clone https://github.com/rakodev/local.git
```

### Add the following to your ~/.bash_profile or ~/.zshrc

```bash
for file in ~/local/aliases/*; do
    source "$file"
done
```

OR add only the one you need, exemple with these 2

```bash
# Docker
source ~/local/aliases/docker.sh
# Git
source ~/local/aliases/git.sh
```

### Reload your shell profile (This example is with zsh)

```shell
source ~/.zshrc
```

### Setup vim settings

```bash
echo "source ~/local/settings/vimrc" > ~/.vimrc
```

### Enable Global gitignore file

```bash
git config --global core.excludesfile ~/local/utils/global.gitignore
```

### Configure Git to only allow fast-forward pushes by default

```bash
git config --global push.ff only
```

### Enable Global Git Template File (Pre-commit hooks)

```bash
git config --global init.templatedir ~/local/git-templates
```

### Other doc

- [AWS](doc/AWS.md)
- [Git](doc/Git.md)
- [Python](doc/Python.md)
- [VsCode](doc/VsCode.md)
- [Git on Windows](doc/Windows-git.md)
- [Zsh on Windows](doc/Windows-zsh.md)
- [Terraform](doc/Terraform.md)
- [Terminal](doc/Terminal.md)
- [TypeScript](doc/TypeScript.md)
