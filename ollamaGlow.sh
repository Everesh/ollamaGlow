#!/usr/bin/env bash

MODEL="${1:-qwen3-coder:30b}"
TEMP=$(mktemp)

tput smcup

trap "tput rmcup; rm -f $TEMP" EXIT

clear

echo "▄▖▜ ▜        ▄▖▜      "
echo "▌▌▐ ▐ ▀▌▛▛▌▀▌▌ ▐ ▛▌▌▌▌"
echo "▙▌▐▖▐▖█▌▌▌▌█▌▙▌▐▖▙▌▚▚▘"
echo "model: $MODEL"

while true; do
  read -e -r -p ">>> " user_input

  if [ $? -ne 0 ] || [ "$user_input" = "exit" ] || [ "$user_input" = "quit" ]; then
    echo "Goodbye!"
    break
  fi

  if [ -z "$user_input" ]; then
    continue
  fi

  >"$TEMP"
  echo "$user_input" | ollama run "$MODEL" | tee "$TEMP"

  if [ "$(wc -l <"$TEMP")" -lt "$(tput lines)" ]; then
    clear
    glow <"$TEMP"
  else
    glow -p <"$TEMP"
    # glow -p exits in default buffer
    tput smcup
    clear
  fi
done
