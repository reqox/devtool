#!/bin/bash

if grep -q '^nvim ()' ~/.bashrc; then
  echo "nvim уже есть в ~/.bashrc, удали старую функцию и запусти заново, чтобы обновить"
  exit 0
fi

cat << 'EOF' >> ~/.bashrc

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

  # В контейнере root, а файлы принадлежат хосту — без safe.directory git отказывается работать
  docker run -it --rm \
    --env GIT_CONFIG_COUNT=1 \
    --env GIT_CONFIG_KEY_0=safe.directory \
    --env GIT_CONFIG_VALUE_0='*' \
    --volume "$root:/mnt/workspace" \
    --workdir /mnt/workspace \
    nvim:sync nvim "${args[@]}"
}
EOF

echo "Готово. Выполни: source ~/.bashrc"
