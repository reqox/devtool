#!/bin/bash

cat << 'EOF' >> ~/.bashrc

nv () {
  local path="${1:-$(pwd)}"
  eval path="$path"
  path="$(realpath "$path" 2>/dev/null || echo "$path")"
  docker run -it --rm --volume "$path:/mnt/workspace" nvim:sync
}
EOF
