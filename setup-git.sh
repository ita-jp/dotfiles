#!/usr/bin/env bash

set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: ./setup-git.sh [--dry-run]

Include this repository's .gitconfig in ~/.gitconfig.
Existing files are backed up first. Repository settings take precedence.
USAGE
}

dry_run=false
case "${1:-}" in
  "") ;;
  --dry-run) dry_run=true ;;
  -h|--help) usage; exit 0 ;;
  *) usage >&2; exit 2 ;;
esac
if [[ $# -gt 1 ]]; then
  usage >&2
  exit 2
fi

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
repo_gitconfig="$repo_dir/.gitconfig"
target="$HOME/.gitconfig"

if [[ ! -r "$repo_gitconfig" ]]; then
  echo "Error: cannot read $repo_gitconfig" >&2
  exit 1
fi
git config --file "$repo_gitconfig" --no-includes --list >/dev/null

if [[ -e "$target" ]]; then
  git config --file "$target" --no-includes --list >/dev/null
  while IFS= read -r include_path; do
    if [[ "$include_path" == "$repo_gitconfig" ]]; then
      echo "Already configured: $target"
      exit 0
    fi
  done < <(git config --file "$target" --no-includes --path --get-all include.path || [[ $? == 1 ]])
fi

if [[ "$dry_run" == true ]]; then
  printf 'Would add include.path to %s:\n  %s\n' "$target" "$repo_gitconfig"
  if [[ -e "$target" ]]; then
    printf 'Would first create a timestamped backup of %s.\n' "$target"
  fi
  exit 0
fi

if [[ -e "$target" ]]; then
  backup="$target.bak.$(date '+%Y%m%d%H%M%S')"
  while [[ -e "$backup" ]]; do
    backup="$backup.$RANDOM"
  done
  cp -p "$target" "$backup"
  echo "Backup created: $backup"
fi

mkdir -p "$(dirname "$target")"
# Let Git quote paths correctly, including spaces, quotes, and backslashes.
git config --file "$target" --no-includes --add include.path "$repo_gitconfig"
echo "Configured: $target"
echo "Git settings take effect immediately."
