#!/usr/bin/env bash
set -euo pipefail
PATTERN='(BEGIN RSA PRIVATE KEY|PRIVATE KEY-----|AKIA[0-9A-Z]{16}|secret_key|api[_-]?key|token=|client_secret|TUNNEL|CLOUDFLARE_[_A-Z]+)'
grep -RInE "$PATTERN" -- articles books images || { echo "No secrets matched."; exit 0; }
