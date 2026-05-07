#!/usr/bin/env bash
set -euo pipefail

dry_run=0
if [[ "${1:-}" == "--dry-run" ]]; then
  dry_run=1
fi

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
versions_file="$root_dir/versions.env"

if [[ ! -f "$versions_file" ]]; then
  echo "versions.env not found: $versions_file" >&2
  exit 1
fi

fetch_latest_tag() {
  local repo="$1"
  local tag
  if command -v curl >/dev/null 2>&1; then
    tag="$(
      curl -fsSL "https://api.github.com/repos/$repo/releases/latest" \
        | sed -n 's/.*"tag_name"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' \
        | head -n 1
    )"
  elif command -v wget >/dev/null 2>&1; then
    tag="$(
      wget -qO- "https://api.github.com/repos/$repo/releases/latest" \
        | sed -n 's/.*"tag_name"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' \
        | head -n 1
    )"
  else
    echo "curl or wget is required" >&2
    exit 1
  fi
  if [[ -z "$tag" ]]; then
    echo "Failed to fetch latest tag for $repo" >&2
    exit 1
  fi
  printf '%s' "$tag"
}

sing_tag="$(fetch_latest_tag "SagerNet/sing-box")"
cloud_tag="$(fetch_latest_tag "cloudflare/cloudflared")"

sing_ver="${sing_tag#v}"
cloud_ver="$cloud_tag"

echo "SING_BOX_VERSION=$sing_ver"
echo "CLOUDFLARED_VERSION=$cloud_ver"

if [[ "$dry_run" -eq 1 ]]; then
  exit 0
fi

tmp="$(mktemp)"
{
  printf 'SING_BOX_VERSION=%s\n' "$sing_ver"
  printf 'CLOUDFLARED_VERSION=%s\n' "$cloud_ver"
} > "$tmp"
mv "$tmp" "$versions_file"
