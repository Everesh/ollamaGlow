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

  # strip down ansii before sending it to glow
  sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g" "$TEMP" | glow
done
