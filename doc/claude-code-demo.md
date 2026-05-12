# Claude Code — Demo Quick Reference

## 1. Setup Claude Code with AWS Bedrock

Full internal guide (auth, model IDs, region, env vars):

→ [Claude Code Setup — Confluence](https://novamedia.atlassian.net/wiki/spaces/GP/pages/1887535234/Claude+Code+Setup)

## 2. Company shared agent skills

We maintain a shared repo of skills, hooks, agents, and MCP servers used across the company:

→ [plg-agent-skills — GitLab](https://gitlab.com/plg-tech/plg/knowledge/plg-agent-skills)

Skills follow the **Agent Skills open standard** (AAIF, Linux Foundation). The portable `.agents/skills/` directory at the repo root contains symlinks to all skills, making them discoverable by any AAIF-compliant tool.

## 3. Most useful built-in slash commands

Type `/` in a Claude Code session to see the full list. The ones below cover 90% of daily use:

### Session control

| Command       | What it does |
| ------------- | ------------ |
| `/help`       | Show all available commands. |
| `/clear`      | Start a fresh conversation — drops all context. Use between unrelated tasks to keep Claude focused and save tokens. |
| `/compact`    | Summarize the conversation so far to free up context without losing the gist. Useful in long sessions. |
| `/resume`     | Re-open a previous conversation from history. |
| `/exit`       | Quit Claude Code. |

### Configuration & state

| Command            | What it does |
| ------------------ | ------------ |
| `/config`          | Open the settings UI — model, theme, hooks, env, etc. |
| `/model`           | Switch model mid-session (Opus / Sonnet / Haiku). |
| `/status`          | Show current working directory, git state, model, context usage. |
| `/usage`           | Show token usage and estimated spend for the current session. |

### Extensions

| Command            | What it does |
| ------------------ | ------------ |
| `/agents`          | List and manage subagents (user + project scope). |
| `/plugin`          | Enable, disable, install, or remove plugins. |
| `/mcp`             | List configured MCP servers and their connection status. |
| `/hooks`           | Inspect hooks wired into settings.json. |

### Project workflow

| Command            | What it does |
| ------------------ | ------------ |
| `/init`            | Generate a starter `CLAUDE.md` by analyzing the current repo. |
| `/review`          | Review the current PR or pending changes on the branch. |
| `/security-review` | Security-focused audit of pending changes (secrets, injection, OWASP). |
| `/memory`          | View, edit, or clear Claude's persistent auto-memory for this project. |

### Terminal tips (not slash commands, but useful)

- `!<command>` — run a shell command in the session so its output lands in the conversation (e.g. `!gcloud auth login`).
- `@<path>` — reference a file or folder so Claude reads it into context.
- `#<text>` — quickly add a note to `CLAUDE.md` without leaving the session.
- `Shift+Tab` — cycle between auto-accept / normal / plan mode.
- `Esc` twice — rewind the conversation to a previous point.

