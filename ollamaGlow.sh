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

  clear

  # the 5 is to account for padding
  if [ "$(($(wc -l <"$TEMP") + 5))" -lt "$(tput lines)" ]; then
    glow <"$TEMP"
  else
    glow -p <"$TEMP"

    # glow -p exits on the wrong buffer
    # im not fixing it, just correcting for it
    tput smcup
    clear
  fi
done
