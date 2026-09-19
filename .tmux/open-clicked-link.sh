#!/usr/bin/env bash
set -euo pipefail

mode="open"
if [[ "${1:-}" == "--check" ]]; then
  mode="check"
  shift
fi

hyperlink="${1:-}"
word="${2:-}"
line="${3:-}"

extract_url() {
  local text="$1"

  [[ -n "$text" ]] || return 1

  if [[ "$text" =~ (https?://[^[:space:]]+|mailto:[^[:space:]]+) ]]; then
    printf '%s\n' "${BASH_REMATCH[1]}"
    return 0
  fi

  return 1
}

extract_matching_url_from_line() {
  local text="$1"
  local needle="$2"
  local rest="$text"
  local candidate=""
  local stripped="$needle"

  while :; do
    case "$stripped" in
      [.,\;\:\]\)\}\>]* | \"* | \'*)
        stripped="${stripped#?}"
        ;;
      *[.,\;\:\]\)\}\>] | *\" | *\')
        stripped="${stripped%?}"
        ;;
      *)
        break
        ;;
    esac
  done

  [[ -n "$stripped" ]] || return 1

  while candidate="$(extract_url "$rest")"; do
    if [[ "$candidate" == *"$stripped"* ]]; then
      printf '%s\n' "$candidate"
      return 0
    fi
    rest="${rest#*"$candidate"}"
    [[ "$rest" != "$text" ]] || break
  done

  return 1
}

url=""
if [[ "$hyperlink" =~ ^(https?://|mailto:) ]]; then
  url="$hyperlink"
elif url="$(extract_url "$word")"; then
  :
elif url="$(extract_matching_url_from_line "$line" "$word")"; then
  :
else
  exit 1
fi

while :; do
  case "$url" in
    *[.,\;\:\]\)\}\>] | *\" | *\')
      url="${url%?}"
      ;;
    *)
      break
      ;;
  esac
done

[[ -n "$url" ]] || exit 1

if [[ "$mode" == "check" ]]; then
  exit 0
fi

open "$url"
