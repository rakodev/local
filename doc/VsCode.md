# VsCode

<https://code.visualstudio.com/docs/getstarted/tips-and-tricks>

## Shortcuts

- F2 = Rename Variable
- F5 = Open Debugger
- F12 = Navigate occurances for a variable
- Home = Go to begening of line
- End = Go to end of line

### Mac

<https://code.visualstudio.com/shortcuts/keyboard-shortcuts-macos.pdf>

- Ctrl - = Navigate back position
- Ctrl Shift - = Navigate forward position
- Cmd p = Open Files
- Option ↑ = Move line up
- Shift Cmd L = Select all occurrences of the selected string for editing.

### Windows

<https://code.visualstudio.com/shortcuts/keyboard-shortcuts-windows.pdf>

- Alt ← = Navigate back position
- Alt → = Navigate forward position
- Ctrl p = Open Files
- Ctrl r = Open Projects
- Alt ↑ = Move line
- Shift Ctrl L = Select all occurrences of the selected string for editing.

### Linux

<https://code.visualstudio.com/shortcuts/keyboard-shortcuts-linux.pdf>

## Install & Use git bash on Windows

### On VsCode

- Push
```ctrl + shift + P```  

- Select
```Terminal: Select Default Profile```

- Choose
```Git Bash```

```Reboot VsCode or Kill the current terminal and reopen it```

## Install zsh on Windows

<!-- - Install [MSYS2](https://www.msys2.org/)
- `pacman -S zsh`
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
