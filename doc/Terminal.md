# Terminal

## Zsh

### Install Oh-My-Zsh

<https://ohmyz.sh/#install>

### To enable autocompletion on zsh, execute this command line

```shell
grep -qxF '# Enable zsh autocompletion' ~/.zshrc || (echo -e "\n# Enable zsh autocompletion" >> ~/.zshrc && echo 'autoload -Uz compinit && compinit' >> ~/.zshrc && . ~/.zshrc)
```

### Zsh plugins

Edit your `.zshrc` file, fine the line starting with `plugins=` and edit it like this:

```shell
plugins=(git zsh-autosuggestions terraform aws pip pipenv pyenv python)
```

- To can see the list of avaiable plugins:

```shell
ls ~/.oh-my-zsh/plugins
```
