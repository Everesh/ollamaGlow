#!/usr/bin/env bash

MODEL="${1:-qwen3-coder:30b}"
GENERATED=$(mktemp)
PROCESSED=$(mktemp)

# Double \ escaped because awk ...
START_THINKING_TAGS=('<think>' 'Thinking\\.\\.\\.' '\\[START_THINKING\\]')
STOP_THINKING_TAGS=('<\\/think>' '\\.\\.\\.done thinking\\.' '\\[STOP_THINKING\\]')

tput smcup

trap "tput rmcup; rm -f $GENERATED $PROCESSED" EXIT

clear

echo "▄▖▜ ▜        ▄▖▜      "
echo "▌▌▐ ▐ ▀▌▛▛▌▀▌▌ ▐ ▛▌▌▌▌"
echo "▙▌▐▖▐▖█▌▌▌▌█▌▙▌▐▖▙▌▚▚▘"
echo "model: $MODEL"

while true; do
  read -e -r -p ">>> " user_input
  [[ "$user_input" =~ ^(exit|quit)$ ]] && break
  [[ -z "$user_input" ]] && continue

  echo "$user_input" | ollama run "$MODEL" | tee "$GENERATED"

  # strip thinking
  awk -v start="$(
    IFS='|'
    echo "${START_THINKING_TAGS[*]}"
  )
" -v stop="$(
    IFS='|'
    echo "${STOP_THINKING_TAGS[*]}"
  )" '
    $0 ~ start {skip=1; next} 
    $0 ~ stop  {skip=0; next} 
    !skip
  ' "$GENERATED" >"$PROCESSED"

  clear

  # the 5 is to account for padding
  if [ "$(($(wc -l <"$PROCESSED") + 5))" -lt "$(tput lines)" ]; then
    glow <"$PROCESSED"
  else
    glow -p <"$PROCESSED"

    # glow -p exits on the wrong buffer
    # im not fixing it, just correcting for it
    tput smcup
    clear
  fi
done
