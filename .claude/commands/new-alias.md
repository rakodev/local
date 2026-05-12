---
description: Scaffold a new alias or function in the right aliases/*.sh file, following repo conventions.
argument-hint: <domain> <short-description>
---

Add a new shell alias or function to this repo based on the user's request: `$ARGUMENTS`

Follow this process exactly:

1. **Parse the request.** The first word is the domain (e.g. `docker`, `git`, `aws`, `tools`, `python`). The rest describes what the command should do.

2. **Pick the file.** Map the domain to `aliases/<domain>.sh`. If no matching file exists, ask the user whether to create a new `aliases/<domain>.sh` before proceeding.

3. **Read the target file** to see its shebang, existing naming style, and where similar aliases are grouped. Match the surrounding style.

4. **Decide: alias or function?**
   - Zero-arg one-liner → `alias`.
   - Takes arguments or multiple steps → function with the standard `[ -z "$1" ]` guard per required arg.

5. **Name it** `<domain>-verb-noun` in kebab-case. The prefix must match the filename.

6. **Write it** with a one-line usage comment directly above. Insert it near related entries in the file (e.g. a new `docker-*` goes near other `docker-*` aliases, not at the bottom).

7. **Show the diff** and remind the user to run `source ~/.zshrc` (or open a new terminal) before the alias is available.

8. **Do not** rename existing aliases, reorder the file, or touch unrelated lines.

If the request is ambiguous (e.g. domain unclear, or the command could live in two files), ask one clarifying question before editing. Otherwise proceed and edit the file directly.
