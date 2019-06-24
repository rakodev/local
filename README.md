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

### Add the following to your ~/.bash_profile
```bash
    # Docker
    source ~/local/aliases/docker.sh
    # Git
    source ~/local/aliases/git.sh
    # Bash
    source ~/local/aliases/bash.sh
    # Symfony Framework (PHP)
    source ~/local/aliases/symfony.sh
```

### Enable your .bash_profile without restarting
```bash
    source ~/.bash_profile
```

### Setup an SSH key
```bash
    ssh-keygen
```

### Copy your public keygen
```bash
    cat ~/.ssh/id_rsa.pub | pbcopy
```
