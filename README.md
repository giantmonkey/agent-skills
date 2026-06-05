# agent-skills

Open source agent skills by [Giant Monkey](https://github.com/giantmonkey). Installable via [`npx skills`](https://github.com/vercel-labs/skills).

## Install

### Quick install for Claude Code

Install one skill straight into Claude Code, no prompts:

```bash
npx skills add github.com/giantmonkey/agent-skills --skill <skill-name> -a claude-code
```

Swap in any skill name from the [table below](#available-skills). The `-a claude-code` flag targets Claude Code so the skill lands in `~/.claude/skills/`.

### All skills

Add every skill in the repo:

```bash
npx skills add github.com/giantmonkey/agent-skills
```

The CLI clones the repo, finds every `SKILL.md` under `skills/`, and prompts you to choose which skills and which agents to install to.

## Available skills

| Skill | Description |
| --- | --- |
| _Coming soon_ | |

## How to contribute

1. Create a folder under `skills/<your-skill>/`.
2. Add a `SKILL.md` with YAML frontmatter:

   ```markdown
   ---
   name: your-skill
   description: One line — what this skill does and when an agent should invoke it. Be specific about trigger keywords.
   ---

   # Your Skill

   Body of the skill.
   ```

3. The folder name and `name:` field must match (lowercase kebab-case).
4. Optional: drop supporting files (e.g. `references/`, `scripts/`) alongside `SKILL.md` — they're copied with the skill.
5. Add a `VERSION` file (start at `1.0.0`) and copy [`scripts/check-update.sh`](scripts/check-update.sh) into your skill's `scripts/` folder. Installed copies check it once a day and tell users to run `npx skills update` when it changes.
6. Add a row to the table above and open a PR.

## Updating a skill

Bump the skill's `VERSION` file in the same PR as your change. That's what triggers the update notice for everyone who has the skill installed. No bump, no notice.

## Layout

```
agent-skills/
├── scripts/
│   └── check-update.sh   ← template, copy into new skills
└── skills/
    └── <skill-name>/
        ├── SKILL.md
        ├── VERSION
        ├── scripts/
        │   └── check-update.sh
        └── ... supporting files ...
```

This is the flat catalog layout the `npx skills` CLI expects.
