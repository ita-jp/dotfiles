#!/bin/bash

cd "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

base_dir="$(pwd)"

files=(
  ".tmux.conf"
  ".vimrc"
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

  if [ ! -e "$source" ]; then
    echo -e "  [ \033[1;31mERROR\033[0m ] Source file/directory does not exist: $source"
    continue
  fi

  if [ -L "$target" ]; then
    echo -e "  [ \033[1;34mSKIP\033[0m ] Symbolic link already exists: $target -> $(readlink $target)"
    continue
  fi

  if [ -e "$target" ]; then
    echo "  Create backup: ${target}.bak"
    mv "$target" "${target}.bak"
  fi

  ln -s "$source" "$target"
  echo -e "  [ \033[1;32mSUCCESS\033[0m ] Create symbolic link: $target -> $(readlink $target)" 
done

echo
echo "Finish"
echo

