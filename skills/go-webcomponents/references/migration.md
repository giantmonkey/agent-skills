# Migrating gomus web components

This is a procedure for an AI coding assistant (or a careful developer) to **upgrade
an integration of `@gomusdev/web-components` from one version to another** — applying
the documented breaking-change edits to the integrator's own HTML/templates, with
review at every step.

It is self-contained: the only authoritative sources are **this file** and
**`./changelog.md`** (the curated, per-version changelog that ships alongside it).
Do not invent migration steps that are not in the changelog. Work only on the
integrator's project files — never edit the library.

Each changelog version has a **`Breaking → migration`** section; every subsection
there is one breaking change with a `Before:` / `After:` pair. Those pairs are the
migration steps this procedure applies.

## Step 1 — Detect the current version

Find which `@gomusdev/web-components` version the project is on. Search in this
priority order and report what you found:

1. **Lockfile** (most reliable — the resolved exact version): grep
   `pnpm-lock.yaml` / `package-lock.json` / `yarn.lock` for `@gomusdev/web-components`.
2. **`package.json`**: the `@gomusdev/web-components` entry in `dependencies` /
   `devDependencies` (a range like `^2.1.0` — strip `^ ~ >=` to a concrete version).
3. **Pinned CDN / script tag**: grep HTML/templates for
   `unpkg.com/@gomusdev/web-components@<version>` (or a `window._go_src` override URL).
4. **The init snippet**: the `version:` value in `go.load({ version: '…' })`.

```bash
grep -rn "@gomusdev/web-components" . --include='*.json' --include='*.html' --include='*.{js,ts,vue,svelte,erb,html.erb}'
grep -rn "go.load(" .
```

If the version is **floating or unknown** (`'latest'`, a wide range like `2.x` /
`2.1.x`, or nothing found), do **not** guess — **ask the integrator** which version
they are on, and tell them how to check (their lockfile is the source of truth).

## Step 2 — Determine the target version

- **Default = latest** = the **first** (top) version entry in `./changelog.md` (it is
  ordered newest-first).
- If the integrator names a specific version, use that. Confirm it has an entry in
  `./changelog.md`; if not, tell them the changelog only covers documented versions
  and pick the nearest documented one, or stop.
- If **target ≤ current**, there is nothing to do (or it's a downgrade — not
  supported). Report and stop.

## Step 3 — Build the migration set

- Read `./changelog.md`. Collect every **`Breaking → migration`** subsection for the
  versions in the half-open range **`(current, target]`** — strictly newer than the
  current version, up to and including the target.
- The changelog is newest-first; **apply oldest→newest** so chained edits compose
  correctly. Reverse the collected list before applying.
- **Present the plan first** (before touching any file): list each version and the
  titled breaking changes it contributes, e.g.

  > - **v2.0.0** — All ticket filter tokens were renamed; `event:ticket` → `event:admission`; a segment without `filters` no longer errors.
  > - **v3.0.0** — `<go-cart>` is now a composable shell; coupon row classes renamed.

  Also note the `New`, `Changed (behavior)`, and `Deprecated` items in range — they
  are surfaced as warnings/suggestions in Step 4, not auto-applied.

## Step 4 — Apply each breaking change, with review

For each breaking change, oldest→newest:

1. Take its `Before:` markup/CSS/JS pattern from the changelog. **Grep the
   integrator's files** for that pattern (the old tag, attribute, or class).
2. For each match, construct the `Before → After` edit.
3. **Show a diff — always labelled with the source version and the breaking-change
   title.** This label is required so the integrator sees exactly which version and
   which change every edit implements:

   ```
   From v3.0.0 — Breaking: <go-cart> is now a composable shell
   <the diff>
   ```

4. The integrator **accepts / rejects / edits** each diff individually. Apply only
   accepted edits.
5. If a `Before:` pattern **cannot be matched mechanically** — a behavioral/JS-level
   change with no markup pattern, dynamic markup, or a framework templating layer
   where the attribute syntax differs (see below) — **do not auto-edit**. Flag it
   **MANUAL**, show the verbatim `Before` / `After` from the changelog, and tell the
   integrator what to change by hand.

Alongside the breaking edits, surface the other in-range items (no auto-edits):

- **`Changed (behavior)`** → a **warning**: "behavior changed in vX — verify your
  flow" (their markup still works but behaves differently).
- **`Deprecated`** → a **warning**: still works, plan removal; name the replacement.
- **`New`** → an **optional suggestion**: "vX added `<go-…>` — available if useful".

**Framework templating layers.** If the project is Vue / React / Angular / Svelte etc.
(check file extensions and `package.json` deps), the attribute syntax differs —
`event-ids` may appear as `:event-ids`, `[eventIds]`, `eventIds={…}`, or a bound prop,
and tags may be wrapped. Broaden the grep beyond raw-HTML attribute syntax, and treat
binding-syntax matches as **MANUAL review** — the changelog's `After` is plain HTML
and won't drop in verbatim.

## Step 5 — Finish

- Print a summary: **applied** / **skipped (rejected)** / **MANUAL follow-ups** /
  **behavior warnings**.
- **Remind the integrator to bump the dependency** to the target version, in whichever
  way Step 1 found them installing it:
  - npm: update `@gomusdev/web-components` in `package.json` and re-lock
    (`pnpm install` / `npm install`).
  - CDN / init snippet: update the pinned `version:` in `go.load({ version: '…' })`
    (or the `unpkg.com/@gomusdev/web-components@<version>` URL).
- Suggest a build + smoke test of the affected pages.

## Notes

- **Authoritative sources only.** `./changelog.md` and this file. Don't invent steps
  not present in the changelog.
- **Already-migrated files are safe.** Edits are grep-driven on the _old_ pattern, so a
  file already on the new markup yields no match — report "no occurrences found, likely
  already migrated" rather than erroring.
- **Unknown current version.** Don't assume the oldest version (it would over-apply
  edits). Confirm with the integrator first; at most, offer to scan their markup for any
  patterns the changelog marks deprecated/removed and report findings without bulk edits.
- **Version older than the changelog floor.** If the current version predates the
  oldest entry in `./changelog.md`, this procedure can only migrate from the oldest
  documented version forward — flag the gap and recommend the integrator contact gomus.
- **Prereleases** (`-next.N`) are not migration targets by default; only stable versions
  appear in the changelog range. Honor an explicit prerelease target only if asked.
