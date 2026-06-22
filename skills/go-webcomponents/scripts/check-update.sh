#!/usr/bin/env bash
# Daily update check. Compares the installed VERSION against the repo's
# current VERSION on GitHub. Prints an update notice on stdout if they
# differ, otherwise prints nothing. Rate-limited to one remote check per
# day. Fails silently (exit 0) on any error — never block the skill.
set -uo pipefail

RAW_BASE="https://raw.githubusercontent.com/giantmonkey/agent-skills/main"

SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILL_NAME="$(basename "$SKILL_DIR")"
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/agent-skills"
STAMP="$CACHE_DIR/$SKILL_NAME.last-check"
NOTICE="$CACHE_DIR/$SKILL_NAME.notice"

mkdir -p "$CACHE_DIR" 2>/dev/null || exit 0

local_version="$(cat "$SKILL_DIR/VERSION" 2>/dev/null | tr -d '[:space:]')"
[ -z "$local_version" ] && exit 0

notify() {
  # $1 = remote version. Only nag if it still differs from what's installed,
  # so the notice goes away as soon as the user updates.
  if [ -n "$1" ] && [ "$1" != "$local_version" ]; then
    echo "UPDATE AVAILABLE: skill '$SKILL_NAME' is at $local_version, latest is $1. Run: npx skills update $SKILL_NAME"
  fi
}

# Within the 24h window: replay the cached result, skip the network.
if [ -f "$STAMP" ]; then
  last="$(cat "$STAMP" 2>/dev/null || echo 0)"
  now="$(date +%s)"
  if [ $((now - last)) -lt 86400 ]; then
    notify "$(cat "$NOTICE" 2>/dev/null | tr -d '[:space:]')"
    exit 0
  fi
fi

date +%s > "$STAMP"
rm -f "$NOTICE"

remote_version="$(curl -fsSL --max-time 10 \
  "$RAW_BASE/skills/$SKILL_NAME/VERSION" 2>/dev/null | tr -d '[:space:]')"
[ -z "$remote_version" ] && exit 0

echo "$remote_version" > "$NOTICE"
notify "$remote_version"

exit 0
