#!/usr/bin/env bash
set -u

target="${1-}"

if [ -z "$target" ]; then
  tmux display-message "rename failed: empty tree target"
  exit 1
fi

case "$target" in
  \$*|=*:)
    prompt="rename session"
    ;;
  @*|=*.)
    prompt="rename window"
    ;;
  %*|*.*)
    prompt="rename pane"
    ;;
  *) prompt="rename selected item" ;;
esac

shell_quote() {
  printf "'%s'" "$(printf "%s" "$1" | sed "s/'/'\\\\''/g")"
}

target_arg="$(shell_quote "$target")"

tmux command-prompt -p "$prompt" \
  "run-shell -b \"$HOME/.tmux/rename-tree-item.sh $target_arg '%%'\""
