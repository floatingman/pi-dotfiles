# pi-agent dotfiles

Portable configuration + skills for [pi](https://github.com/earendil-works/pi-coding-agent),
migrated off Claude Code. Everything pi needs lives in this repo; the standard
home-directory locations are symlinks into it.

## Layout

```
dotfiles/
├── agents/skills/      # all skills (read by pi from ~/.agents/skills automatically)
├── pi/settings.json    # pi config (provider, model, packages, theme)
├── pi/mcp.json         # MCP server config
├── install.sh          # (re)creates the symlinks on a new machine
└── .gitignore
```

## What's wired up

| Standard location (symlink)        | Points to                    |
|------------------------------------|------------------------------|
| `~/.agents/skills`                 | `dotfiles/agents/skills`     |
| `~/.pi/agent/settings.json`        | `dotfiles/pi/settings.json`  |
| `~/.pi/agent/mcp.json`             | `dotfiles/pi/mcp.json`       |

Pi reads `~/.agents/skills` as a global skill location with **no** `skills` entry in
`settings.json`, so skills travel with this repo automatically.

## Set up on a new machine

```bash
git clone git@github.com:floatingman/pi-dotfiles.git ~/dotfiles
cd ~/dotfiles && ./install.sh
```

Then restore the local package dependency referenced in `settings.json`:

```bash
git clone <pi-reviewer remote> ~/git/pi-reviewer
```

(`settings.json` lists `"../../git/pi-reviewer"` as a package — relative to `~/.pi/agent/`,
that resolves to `~/git/pi-reviewer`.)

## Notes

- **Editing configs in pi** (e.g. via `/settings`) writes *through* the symlinks into this
  repo, so changes are picked up by `git` automatically — just commit them.
- **Skills migrated from Claude Code ("ECC" bundle)** were copied from `~/.claude/skills`.
  Functional references (`~/.claude/skills/...`, `~/.claude.json`) were rewritten to pi paths.
  A handful of skills are *Claude-coupled* (they reference Claude runtime state like
  `~/.claude/homunculus/`, hooks, or observer logs) and were left as-is; see "Claude-coupled
  skills" below. They load fine but their Claude-specific features won't run under pi.
- The private remote is `git@github.com:floatingman/pi-dotfiles.git`.

## Claude-coupled skills (partial compatibility)

These reference Claude Code runtime state and may need adaptation for full pi support:
`continuous-learning-v2`, `autonomous-loops`, `strategic-compact`, `configure-ecc`,
`running-claude-code-via-litellm-copilot`, `knowledge-ops`, `skill-stocktake`,
`shannon`, `team-builder`, `council`, `search-first`.
