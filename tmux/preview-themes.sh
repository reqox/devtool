#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUT="theme-test"
PREV="theme-prev"

declare -A THEME=(
  [blue]=""
  [blue-flat]="theme-blue.conf"
  [nord]="theme-nord.conf"
  [nord-pwl]="theme-nord-powerline.conf"
  [warm]="theme-warm.conf"
  [warm-pwl]="theme-warm-powerline.conf"
  [purple]="theme-purple.conf"
  [purple-pwl]="theme-purple-powerline.conf"
  [mono]="theme-mono.conf"
  [alert]="theme-alert.conf"
  [simple]="theme-simple.conf"
)

declare -A TITLE=(
  [blue]="blue · powerline (main)"
  [blue-flat]="blue · flat"
  [nord]="nord · flat"
  [nord-pwl]="nord · powerline"
  [warm]="warm · flat"
  [warm-pwl]="warm · powerline"
  [purple]="purple · flat"
  [purple-pwl]="purple · powerline"
  [mono]="mono · flat"
  [alert]="alert · flat"
  [simple]="simple · flat"
)

KEYS=(blue blue-flat nord nord-pwl warm warm-pwl purple purple-pwl mono alert simple)

sock() { printf '%s-%s' "$PREV" "$1"; }

clean() {
  tmux -L "$OUT" kill-server 2>/dev/null || true
  local k
  for k in "${KEYS[@]}"; do
    tmux -L "$(sock "$k")" kill-server 2>/dev/null || true
  done
}

pane_text() {
  printf "printf 'theme: %s\\n\\n  status bar\\n  window list\\n  pane borders\\n  copy mode\\n\\n  prefix: C-a\\n'; exec sleep 100000" "$1"
}

loop_cmd() {
  printf "while :; do env -u TMUX tmux -L %s attach -t %s; sleep 0.3; done" "$(sock "$1")" "$1"
}

build_inner() {
  local key=$1 file=${THEME[$1]} s
  s=$(sock "$key")

  tmux -L "$s" -f "$HOME/.tmux.conf" new -d -s "$key" -n edit
  [[ -n "$file" ]] && tmux -L "$s" source-file "$ROOT/themes/$file"
  tmux -L "$s" set -g set-titles off

  tmux -L "$s" respawn-pane -k -t "$key:edit.0" "$(pane_text "$key")"
  tmux -L "$s" split-window -h -t "$key:edit" "printf 'second pane\\n'; exec sleep 100000"
  tmux -L "$s" new-window -d -t "$key" -n build "sleep 2; printf 'build: ok\\n'; exec sleep 100000"
  tmux -L "$s" new-window -d -t "$key" -n logs "printf '12:00:01 INFO ready\\n12:00:02 WARN retry\\n'; exec sleep 100000"

  tmux -L "$s" select-window -t "$key:edit"
  tmux -L "$s" select-pane -t "$key:edit.0"
}

add_panes() {
  local win=$1; shift
  local k pid
  for k in "$@"; do
    pid=$(tmux -L "$OUT" split-window -t "themes:$win" -P -F '#{pane_id}' "$(loop_cmd "$k")")
    tmux -L "$OUT" select-pane -t "$pid" -T "${TITLE[$k]}"
  done
  tmux -L "$OUT" select-layout -t "themes:$win" tiled
}

new_win() {
  local win=$1 first=$2; shift 2
  local pid
  pid=$(tmux -L "$OUT" new-window -d -t themes -n "$win" -P -F '#{pane_id}' "$(loop_cmd "$first")")
  tmux -L "$OUT" select-pane -t "$pid" -T "${TITLE[$first]}"
  add_panes "$win" "$@"
}

build_outer() {
  tmux -L "$OUT" -f /dev/null new -d -s themes -n powerline
  tmux -L "$OUT" source-file "$ROOT/themes/theme-simple.conf"

  tmux -L "$OUT" set -g status-left '#[fg=#dfe4ea,bold] themes #[nobold]#[fg=#333941]│ '
  tmux -L "$OUT" set -g pane-border-status top
  tmux -L "$OUT" set -g pane-border-format ' #{pane_title} '
  tmux -L "$OUT" set -g pane-border-style 'fg=#333941'
  tmux -L "$OUT" set -g pane-active-border-style 'fg=#9db4d0'

  tmux -L "$OUT" respawn-pane -k -t "themes:powerline.0" "$(loop_cmd blue)"
  tmux -L "$OUT" select-pane -t "themes:powerline.0" -T "${TITLE[blue]}"
  tmux -L "$OUT" select-layout -t "themes:powerline" tiled
  add_panes powerline nord-pwl warm-pwl purple-pwl

  new_win flat blue-flat nord warm purple
  new_win other mono alert simple

  tmux -L "$OUT" select-window -t "themes:powerline"
}

case "${1:-}" in
  --clean) clean; echo "killed $OUT and all $PREV-* servers"; exit 0 ;;
  --list) tmux -L "$OUT" list-panes -a -F '#{window_name}  #{pane_title}' 2>/dev/null || true; exit 0 ;;
esac

clean
for k in "${KEYS[@]}"; do build_inner "$k"; done
build_outer

echo "ready. attach with: tmux -L $OUT attach"
echo "clean up with:    $0 --clean"
