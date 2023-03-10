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

OR add only the one you need

```bash
# Docker
source ~/local/aliases/docker.sh
# Git
source ~/local/aliases/git.sh
# Shell
source ~/local/aliases/shell.sh
# Symfony Framework (PHP)
source ~/local/aliases/symfony.sh
# Network
source ~/local/aliases/network.sh
# Kubernetes
source ~/local/aliases/kubernetes.sh
# AWS
source ~/local/aliases/aws.sh
# Terraform
source ~/local/aliases/terraform.sh  
```

### Reload your shell profile

```bash
source ~/.bash_profile
```

OR

```bash
source ~/.zshrc
```

### Setup an SSH key

```bash
ssh-keygen
```

### Copy your public keygen

```bash
cat ~/.ssh/id_rsa.pub | pbcopy
```

### Setup vim settings

```bash
echo "source ~/local/settings/vimrc" > ~/.vimrc
```

### Enable Global gitignore file

```bash
git config --global core.excludesfile ~/local/utils/global.gitignore
```

### Enable Global Git Template File (Pre-commit hooks)

```bash
git config --global init.templatedir ~/local/git-templates
```
