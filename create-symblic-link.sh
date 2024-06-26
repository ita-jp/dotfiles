#!/bin/bash

cd "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

base_dir="$(pwd)"

files=(
  ".tmux.conf"
  ".vim"
)

echo
echo "Start.."

for file in "${files[@]}"; do
  target="$HOME/$file"
  source="$base_dir/$file"

  echo
  echo "$file:"
  echo "  source: $source"
  echo "  target: $target"

  if [ -L "$target" ]; then
    echo "  Symbolic link already exists: $target -> $(readlink $target)"
    echo "  Skip"
    continue
  fi

  if [ -e "$target" ]; then
    echo "  Create backup: ${target}.bak"
    mv "$target" "${target}.bak"
  fi

  ln -s "$source" "$target"
  echo "  Create symbolic link: $target -> $(readlink $target)" 
done

echo
echo "Finish"
echo

