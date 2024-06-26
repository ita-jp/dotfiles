#!/bin/bash

cd "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

base_dir="$(pwd)"
echo "base_dir = ${base_dir}"

files=(
  ".tmux.conf"
)

for file in "${files[@]}"; do
  target="$HOME/$file"
  source="$base_dir/$file"

  # backup
  if [ -e "$target" ] || [ -L "$target" ]; then
    echo "Create backup: ${target}.bak"
    mv "$target" "${target}.bak"
  fi


  ln -s "$source" "$target"
  echo "Create symbolic link: $(ls -la $HOME | grep $(basename $target) | awk '{print $9, $10, $11}')"
done

echo "Finish all symbolic links."
