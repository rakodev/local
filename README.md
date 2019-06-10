### Clone this repository
```bash
    cd ~
    git clone https://github.com/rakodev/local.git
```

### Add the following to your ~/.bash_profile or ~/.bashr
```bash
    source ~/local/docker.sh
    source ~/local/git.sh
```

### Setup an SSH key
```bash
    ssh-keygen
```

### Copy your public keygen
```bash
    cat ~/.ssh/id_rsa.pub | pbcopy
```

### Create a ~/.gitexcludes file and paste in this:
```bash
    .DS_Store
    .idea
```

