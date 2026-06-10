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

1. **Naming:** `<domain>-verb-noun`, kebab-case, domain matches the filename. Examples: `docker-list-all-containers`, `git-delete-local-pushed-branches`, `tools-search-string-in-folder`. The prefix is how the user discovers commands with tab completion — never drop it.
   - **Correct:** `docker-list-all-containers`, `git-branch-remove`, `tools-search-string`
   - **Incorrect:** `d-remove-by-image-name`, `dc-rebuild`, `tools-search_string`
   - **Rule:** Always use the full domain name (e.g., `docker-`, `git-`, `tools-`), never abbreviations like `d-` or `dc-`.
   - **Case:** kebab-case only. No CamelCase, no snake_case.

2. **Argument validation:** functions that take required args must guard each one and `return 0` on missing input:

