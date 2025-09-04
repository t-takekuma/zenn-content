#!/usr/bin/env bash
set -euo pipefail
TARGET_DIRS=("articles" "books" "images")
PATTERN='(BEGIN RSA PRIVATE KEY|PRIVATE KEY-----|AKIA[0-9A-Z]{16}|secret_key|api[_-]?key|token=|client_secret|TUNNEL|CLOUDFLARE_[_A-Z]+)'
changed=$(git diff --cached --name-only -- "${TARGET_DIRS[@]}" || true)
[ -z "$changed" ] && { echo "[pre-commit] no staged changes"; exit 0; }
failed=0
while IFS= read -r f; do
  case "$f" in *.md|*.json|*.yaml|*.yml|*.conf|*.txt) : ;; *) continue ;; esac
  if git show ":$f" | grep -E -n "$PATTERN" >/dev/null 2>&1; then
    echo "ERROR: potential secret in $f"; failed=1
  fi
done <<< "$changed"
[ "$failed" -eq 0 ] && echo "[pre-commit] OK" || { echo "Remove secrets / use mock values."; exit 1; }
