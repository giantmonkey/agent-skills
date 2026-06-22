# Agent Skills

A marketplace of open source agent skills by [Giant Monkey](https://github.com/giantmonkey).

Skills teach your AI coding agent a specific trick: how to write a commit message, run a deploy, review a PR your way. Install the ones you want and the agent picks them up automatically.

Two ways to install: as **Claude Code plugins** (one command inside Claude Code) or with **`npx skills`** (works across agents). Pick whichever fits.

## Install with Claude Code

Add this repo as a plugin marketplace once:

```
/plugin marketplace add giantmonkey/agent-skills
```

Then install any skill from the [table below](#whats-inside):

```
/plugin install conventional-commit@agent-skills
```

Browse everything available with `/plugin` and the marketplace UI.

## Install with npx skills

Grab one skill straight into Claude Code, no prompts:

```bash
npx skills add github.com/giantmonkey/agent-skills --skill conventional-commit -a claude-code
```

Or add every skill in the repo and pick interactively:

```bash
npx skills add github.com/giantmonkey/agent-skills
```

`npx skills` works with other agents too. Drop the `-a claude-code` flag and it'll ask where to install.

## What's inside

| Skill | What it does |
| --- | --- |
| [`conventional-commit`](skills/conventional-commit/) | Writes a Conventional Commits message from your staged changes. |
| [`go-webcomponents`](skills/go-webcomponents/) | Integrate the Gomus museum-ticketing web components (`<go-*>` custom elements) into any site. |

## Contributing a skill

1. Create a folder under `skills/<your-skill>/`.
2. Add a `SKILL.md` with YAML frontmatter:

   ```markdown
   ---
   name: your-skill
   description: One line — what this skill does and when an agent should invoke it. Be specific about the trigger words.
   ---

   # Your Skill

   The instructions the agent follows.
   ```

3. The folder name and the `name:` field must match. Lowercase, kebab-case.
4. Add a `VERSION` file starting at `1.0.0`.
5. Copy [`scripts/check-update.sh`](scripts/check-update.sh) into your skill's `scripts/` folder. Installed copies check it once a day and tell users to run `npx skills update` when the version changes.
6. Optional: drop supporting files (`references/`, `scripts/`, etc.) next to `SKILL.md`. They get copied with the skill.
7. Add a row to the [table above](#whats-inside) and a plugin entry to [`.claude-plugin/marketplace.json`](.claude-plugin/marketplace.json) so it shows up for Claude Code users.
8. Open a PR.

### Writing a good description

The `description:` is the only thing the agent sees when deciding whether to use your skill. Make it earn its place. Say what the skill does and name the words a user would say to trigger it. Vague descriptions never get invoked.

## Updating a skill

Bump the skill's `VERSION` file in the same PR as your change. That's what triggers the update notice for everyone who has it installed. No bump, no notice.

## Installing an older version

`main` always holds the latest skill. Each release is also git-tagged `<skill>-v<version>` (e.g. `go-webcomponents-v3.6.0`), so you can install the version that matches the library you run:

- Pull just that skill at the tag with degit, then move it into your agent's skills directory (e.g. `~/.claude/skills/`):

  ```bash
  npx degit giantmonkey/agent-skills/skills/go-webcomponents#go-webcomponents-v3.6.0 go-webcomponents
  ```

- Or download the skill bundle attached to the matching [GitHub Release](https://github.com/giantmonkey/agent-skills/releases) and unzip it there.

- Claude Code plugin users can pin the marketplace to the tag:

  ```
  /plugin marketplace add https://github.com/giantmonkey/agent-skills.git#go-webcomponents-v3.6.0
  ```

## Layout

```
agent-skills/
├── .claude-plugin/
│   └── marketplace.json     ← lists each skill as an installable plugin
├── scripts/
│   └── check-update.sh      ← template, copy into new skills
└── skills/
    └── <skill-name>/
        ├── SKILL.md
        ├── VERSION
        ├── scripts/
        │   └── check-update.sh
        └── ... supporting files ...
```

This is the flat catalog layout `npx skills` expects, with a marketplace manifest layered on top for Claude Code.

## License

MIT.
