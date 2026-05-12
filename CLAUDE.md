# local — repo guide for Claude

This repo is a personal dotfiles / shell-aliases bundle. It is sourced from `~/.zshrc` or `~/.bash_profile` on macOS. Most work here is adding or refining shell aliases and functions.

## Layout

- `aliases/*.sh` — one file per domain (`git.sh`, `docker.sh`, `aws.sh`, `terraform.sh`, `python.sh`, `tools.sh`, ...). All files in this dir are sourced at shell startup.
- `scripts/` — standalone scripts invoked by aliases.
- `settings/` — editor/shell config (e.g. `vimrc`).
- `mac-install/` — bootstrap install script for a fresh macOS machine.
- `git-templates/` — template dir for `git init` (pre-commit hooks).
- `doc/` — topic-specific markdown notes.
- `utils/global.gitignore` — the file pointed to by `core.excludesfile`.

## Conventions for aliases

When adding a new alias or function to `aliases/*.sh`, follow the existing style:

1. **Naming:** `<domain>-verb-noun`, kebab-case, domain matches the filename. Examples: `docker-list-all-containers`, `git-delete-local-pushed-branches`, `tools-search-String-in-Folder`. The prefix is how the user discovers commands with tab completion — never drop it.
2. **Argument validation:** functions that take required args must guard each one and `return 0` on missing input:
   ```sh
   my-func() {
       if [ -z "$1" ]; then
           echo "<what is missing> is missing!";
           return 0;
       fi
       ...
   }
   ```
3. **Usage comments:** add a one-line comment above the alias/function describing what it does or a usage example. Link to docs/StackOverflow when the command is non-obvious.
4. **Shebang:** keep the existing shebang of the file (`#!/bin/sh` or `#!/bin/bash`). Don't introduce bash-only syntax (arrays, `[[ ]]`) in a `#!/bin/sh` file.
5. **Placement:** put the new alias in the matching domain file. Create a new `aliases/<domain>.sh` file only if no existing domain fits — it will be auto-sourced.

## Platform

macOS only. Use BSD-flavored flags (`find`, `sed`, `grep`) — GNU-only flags break silently. `pbcopy`/`pbpaste` are fine.

## Testing a change

After editing `aliases/*.sh`, the user needs to `source ~/.zshrc` (or open a new shell) to pick it up. Don't suggest running the function inline unless you've actually sourced the file in the same Bash tool invocation.

## Not in scope

Don't reformat existing aliases, don't rename them (users have muscle memory), and don't add a package manager or build step. This repo is intentionally plain shell.
