#!/usr/bin/env bash

set -euo pipefail

usage() {
  cat <<'EOF'
Usage: ./setup-zsh.sh [--dry-run]

Add this repository's .zshrc to ~/.zshrc. Existing files are backed up first.
EOF
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
repo_zshrc="$repo_dir/.zshrc"
target="$HOME/.zshrc"
begin_marker="# >>> dotfiles zsh >>>"
end_marker="# <<< dotfiles zsh <<<"

if [[ ! -r "$repo_zshrc" ]]; then
  echo "Error: cannot read $repo_zshrc" >&2
  exit 1
fi

if [[ -f "$target" ]] && { grep -Fq "$begin_marker" "$target" || grep -Fq "$repo_zshrc" "$target"; }; then
  echo "Already configured: $target"
  exit 0
fi

# Bash's %q emits a shell-safe path, including when the repository path has spaces.
read_line="source $(printf '%q' "$repo_zshrc")"
block="$begin_marker\nif [[ -r $(printf '%q' "$repo_zshrc") ]]; then\n  $read_line\nfi\n$end_marker"

if [[ "$dry_run" == true ]]; then
  printf 'Would append to %s:\n\n%b\n' "$target" "$block"
  if [[ -f "$target" ]]; then
    printf '\nWould first create a timestamped backup of %s.\n' "$target"
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
{
  if [[ -f "$target" && -s "$target" ]]; then
    # Separate the managed block from existing content with one blank line.
    if [[ "$(tail -c 1 "$target" | wc -l | tr -d ' ')" == 1 ]]; then
      printf '\n'
    else
      printf '\n\n'
    fi
  fi
  printf '%b\n' "$block"
} >> "$target"

echo "Configured: $target"
echo "Open a new terminal or run: source ~/.zshrc"
