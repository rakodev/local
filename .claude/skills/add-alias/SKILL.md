---
name: add-alias
description: Use when the user asks to add, create, or write a new shell alias or function to this dotfiles repo (e.g. "add an alias for X", "make a function that does Y", "I want a shortcut for Z"). Handles picking the right aliases/*.sh file, applying the repo's naming convention, and wiring in the standard argument-validation pattern.
---

# Adding an alias to this repo

Aliases live in `aliases/*.sh`, one file per domain. Every file in that dir is sourced at shell startup.

## Step 1 — Pick the right file

Match the command's domain to an existing file:

| Domain                                 | File              |
| -------------------------------------- | ----------------- |
| git                                    | `aliases/git.sh`  |
| docker / docker-compose                | `aliases/docker.sh` |
| kubernetes                             | `aliases/kubernetes.sh` |
| aws cli                                | `aliases/aws.sh`  |
| terraform                              | `aliases/terraform.sh` |
| python / pip / pyenv / venv            | `aliases/python.sh` |
| ffmpeg / images / pictures             | `aliases/ffmpeg.sh`, `aliases/images.sh`, `aliases/picture.sh` |
| disk usage                             | `aliases/disk_space.sh` |
| shell / general utilities              | `aliases/tools.sh` |
| network                                | `aliases/network.sh` |

If no file fits, create `aliases/<domain>.sh` — it will be auto-sourced. Use `#!/bin/sh` unless you need bash features.

## Step 2 — Name it

Format: `<domain>-verb-noun` in kebab-case, where `<domain>` matches the filename prefix.

Good:
- `docker-list-all-containers`
- `git-delete-local-pushed-branches`
- `aws-assume-role`
- `tools-zip-all-in-current-directory`

Bad:
- `list_containers` (no prefix, snake_case)
- `gitCleanup` (camelCase, vague verb)
- `dclean` (no domain, abbreviated)

The domain prefix is how the user discovers commands via tab-completion. Never drop it.

## Step 3 — Use the right construct

- **`alias`** — for a one-liner with no parameters.
- **function** — whenever the command takes arguments or runs multiple steps.

## Step 4 — Validate arguments (functions only)

Every required arg must be guarded. Use exactly this pattern (matches the rest of the repo):

```sh
my-domain-thing() {
    if [ -z "$1" ]; then
        echo "<what the arg is> is missing!";
        return 0;
    fi
    # ... command here, referencing $1
}
```

For multiple required args, repeat the block for `$2`, `$3`, etc. — each with its own `echo` describing what's missing. Don't collapse them into a single check.

## Step 5 — Add a usage comment

One line above the alias/function, minimum. Prefer an example of real usage or a link to docs/StackOverflow when the command is non-obvious:

```sh
# tools-search-in-Folder-this-File . "pre*"
tools-search-in-Folder-this-File() {
    ...
}
```

## Step 6 — Respect the shebang

If the file starts with `#!/bin/sh`, do not use bash-only features (`[[ ]]`, arrays, `==`, process substitution `<(...)`). Either rewrite in POSIX or move the function to a `#!/bin/bash` file like `tools.sh`.

## Step 7 — macOS-only

This runs on macOS. Use BSD flags for `find`, `sed`, `grep`. `pbcopy`/`pbpaste` are available. GNU-only flags like `sed -i ''` vs `sed -i` differ — default to BSD.

## Step 8 — Don't tell the user to "just run it"

After editing, the user must `source ~/.zshrc` (or open a new shell) before the alias is available. Mention that in the reply.
