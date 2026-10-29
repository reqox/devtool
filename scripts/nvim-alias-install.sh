#!/bin/bash
set -euo pipefail

BEGIN="# >>> devtool nvim >>>"
END="# <<< devtool nvim <<<"
BASHRC="$HOME/.bashrc"

BLOCK=$(cat <<'EOF'
# >>> devtool nvim >>>
nvim () {
  local args=() roots=() a p root

  # Разбираем аргументы: флаги nvim пропускаем как есть, пути приводим к абсолютным.
  # (~ раскрывает сам bash до вызова функции, eval не нужен)
  for a in "$@"; do
    if [[ "$a" == -* ]]; then
      args+=("$a")
      continue
    fi
    p="$(realpath -m -- "$a")"
    args+=("$p")
    # Для директории монтируем её саму, для файла (в т.ч. нового) — родительскую папку
    if [[ -d "$p" ]]; then roots+=("$p"); else roots+=("$(dirname "$p")"); fi
  done

  # Без путей — как обычный `nvim`: монтируем текущую директорию
  if [[ ${#roots[@]} -eq 0 ]]; then
    roots=("$PWD")
  fi

  # Корень монтирования — общий предок всех путей
  root="${roots[0]}"
  for p in "${roots[@]:1}"; do
    while [[ "$root" != "/" && "$p/" != "$root/"* ]]; do
      root="$(dirname "$root")"
    done
  done

  if [[ "$root" == "/" ]]; then
    echo "nvim: пути слишком разные, общий корень — /, отказываюсь монтировать его" >&2
    return 1
  fi

  # Переписываем абсолютные пути хоста в пути внутри контейнера
  local i
  for i in "${!args[@]}"; do
    if [[ "${args[$i]}" == "$root" ]]; then
      args[$i]="."
    elif [[ "${args[$i]}" == "$root/"* ]]; then
      args[$i]="${args[$i]#"$root"/}"
    fi
  done

  docker run -it --rm \
    --user "$(id -u):$(id -g)" \
    --detach-keys "ctrl-^" \
    --env HOME=/home/dev \
    --env TERM=xterm-256color \
    --tmpfs "/home/dev:rw,exec,mode=1777" \
    --volume "$root:/mnt/workspace" \
    --workdir /mnt/workspace \
    nvim-sync:0.1.0 nvim "${args[@]}"
}
# <<< devtool nvim <<<
EOF
)

touch "$BASHRC"

# Пересобираем .bashrc без прошлой версии блока, а также без старой функции,
# которая была добавлена до появления маркеров.
tmp=$(mktemp)
awk -v begin="$BEGIN" -v end="$END" '
  $0 == begin { skip = 1; next }
  $0 == end   { skip = 0; next }
  skip { next }
  /^nvim \(\) \{$/ { legacy = 1; next }
  legacy && /^\}$/ { legacy = 0; next }
  legacy { next }
  { print }
' "$BASHRC" > "$tmp"

printf '\n%s\n' "$BLOCK" >> "$tmp"
cat "$tmp" > "$BASHRC"
rm -f "$tmp"

echo "Готово. Выполни: source ~/.bashrc"
