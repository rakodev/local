# Zsh on Windows

## Blog post

- <https://dominikrys.com/posts/zsh-in-git-bash-on-windows/>

## Install zsh on Windows

- **Make sure you have first [install Git](./Windows-git.md)**

<!-- - Install [MSYS2](https://www.msys2.org/)
- There might be an easier way to install it via [Pacman](https://wiki.archlinux.org/title/pacman)
- See [this thread](https://stackoverflow.com/questions/32712133/package-management-in-git-for-windows-git-bash) for more information
OR -->
- Install an extractor, for example [Peazip](https://peazip.github.io/) or [7zip](https://www.7-zip.org/)
- Download this zsh package [File](https://packages.msys2.org/package/zsh)
- Extract this into your Git folder, this is likely to be under `C:\Program Files\Git`
AND
- Approve any changes while extracting
- Open Git Bash and run `zsh`
- `Enter 1`
- `Enter 2`
- `Enter 1`:  Turn on completion with the default options.
- Press 0 to save the settings.
- Configure Zsh as the default shell by appending the following to your `~/.bashrc` file:
- `vim .bashrc` and instert this:

```shell
if [ -t 1 ]; then
  exec zsh
fi
```

- Then install [Oh-my-zsh](https://ohmyz.sh/#install)

```shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
``
