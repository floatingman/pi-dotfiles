# pi skills

Global skills for [pi](https://github.com/earendil-works/pi-coding-agent), cloned
in place to `~/.pi/agent/skills/` by chezmoi (see the dotfiles repo's
`run_once_install-pi-agent.sh`).

## Editing

Real files at the consumption path — edit here and push:

    cd ~/.pi/agent/skills
    $EDITOR <skill>/SKILL.md
    git add -A && git commit -m "..." && git push

pi reads `~/.pi/agent/skills/` at startup, so restart pi after structural changes.

## Layout

Each top-level directory is one skill (`<name>/SKILL.md` + assets). This repo is
cloned directly to `~/.pi/agent/skills/`, so skill dirs live at the repo root.
