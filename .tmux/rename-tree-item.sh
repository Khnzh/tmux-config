#!/usr/bin/env bash
set -u

target="${1-}"
name="${2-}"

if [ -z "$target" ]; then
  tmux display-message "rename failed: empty tree target"
  exit 1
fi

if [ -z "$name" ]; then
  tmux display-message "rename cancelled: empty name"
  exit 0
fi

case "$target" in
  \$*)
    tmux rename-session -t "$target" "$name"
    ;;
  =*:)
    session_target="${target%:}"
    tmux rename-session -t "$session_target" "$name"
    ;;
  @*)
    tmux rename-window -t "$target" "$name"
    ;;
  =*.)
    window_target="${target%.}"
    tmux rename-window -t "$window_target" "$name"
    ;;
  %*)
    tmux select-pane -t "$target" -T "$name"
    ;;
  =*.*)
    tmux select-pane -t "$target" -T "$name"
    ;;
  *)
    tmux display-message "rename failed: unknown target $target"
    exit 1
    ;;
esac
