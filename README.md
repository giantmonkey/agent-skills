# go-webcomponents skill

An AI integration skill for the **Gomus museum-ticketing web components** (`<go-*>` custom elements), by [Giant Monkey](https://github.com/giantmonkey).

It teaches your AI assistant how to embed and use the components — every public tag with its attributes and events, the ticket-selection filters, integration flows, and version migration. The docs are generated from the library's own source, and the compiled bundle ships alongside them so the assistant can dig into real behaviour when the docs fall short.

Works with any AI: install into Claude Code, Cursor, and 70+ other agents via `npx skills`, install as a Claude Code plugin, or point any chat assistant at the docs.

## Install

### Claude Code (plugin)

```
/plugin marketplace add giantmonkey/agent-skills
/plugin install go-webcomponents@agent-skills
```

### Any agent (npx skills)

```bash
npx skills add github.com/giantmonkey/agent-skills --skill go-webcomponents -a claude-code
```

Drop `-a claude-code` to be prompted for your agent (Cursor, Windsurf, and others are supported).

### ChatGPT / Gemini / other chat assistants

Point the assistant at the docs and ask it to follow them:

```
https://github.com/giantmonkey/agent-skills/tree/main/skills/go-webcomponents
```

## Installing an older version

`main` always holds the latest skill, matching the latest `@gomusdev/web-components` release. Each release is git-tagged `go-webcomponents-v<version>`, so you can install the version that matches the library you run:

- Pull it at the tag with degit, then move it into your agent's skills directory (e.g. `~/.claude/skills/`):

  ```bash
  npx degit giantmonkey/agent-skills/skills/go-webcomponents#go-webcomponents-v3.6.0 go-webcomponents
  ```

- Or download the bundle attached to the matching [GitHub Release](https://github.com/giantmonkey/agent-skills/releases) and unzip it there.

- Claude Code plugin users can pin the marketplace to the tag:

  ```
  /plugin marketplace add https://github.com/giantmonkey/agent-skills.git#go-webcomponents-v3.6.0
  ```

## How it's maintained

The skill is auto-generated from the gomus-webcomponents source and published here by CI on every release. Don't edit `skills/go-webcomponents/` by hand — fixes belong in the library's docs upstream, and the next release regenerates everything here.

## License

MIT.
