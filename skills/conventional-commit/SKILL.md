---
name: conventional-commit
description: Write a git commit message that follows the Conventional Commits spec, based on the staged changes. Use when the user asks to "commit", "write a commit message", "conventional commit", or after staging changes and wanting them committed cleanly.
---

# Conventional Commit

Turn staged changes into a clean commit message that follows the [Conventional Commits](https://www.conventionalcommits.org) spec.

## When to use

The user staged some changes and wants them committed, or asks for a commit message. If nothing is staged yet, ask whether to stage everything (`git add -A`) or let the user stage first.

## How to write the message

1. Look at what actually changed: run `git diff --staged`. Don't guess from the file names.
2. Pick the type that matches the change:

   - `feat` — a new feature
   - `fix` — a bug fix
   - `docs` — docs only
   - `style` — formatting, no code meaning change
   - `refactor` — code change that neither fixes a bug nor adds a feature
   - `perf` — performance
   - `test` — adding or fixing tests
   - `build` — build system or dependencies
   - `ci` — CI config
   - `chore` — anything else that doesn't touch src or tests

3. Add a scope in parentheses when it sharpens the message: `feat(auth): ...`. Skip it when it doesn't.
4. Write the subject in the imperative, lowercase, under 50 characters, no trailing period: "add", not "added" or "Adds".
5. If the change needs context, add a body after a blank line. Explain why, not what (the diff already shows what).
6. Breaking change? Add `!` after the type/scope (`feat!:`) and a `BREAKING CHANGE:` footer.

## Format

```
<type>(<optional scope>): <subject>

<optional body>

<optional footer>
```

## Examples

```
feat(parser): support trailing commas in arrays
```

```
fix: stop crash when the config file is empty

readConfig() assumed at least one key. Guard the empty case and
fall back to defaults.
```

## Then commit

Once the message is right, run the commit. Show the user the message first if there's any ambiguity about the type or scope.
