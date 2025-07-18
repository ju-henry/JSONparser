#!/bin/bash

mkdir -p twitter_heavy
target_size=1048576 # 1MB

for i in {0..99}; do
  src="twitter/object_${i}.json"
  dest="twitter_heavy/object_${i}.json"

  # Start with the original
  cp "$src" "$dest"

  n=0
  while [ "$(stat -c%s "$dest")" -lt "$target_size" ]; do
    # Bash brace expansion to create 100 new "fillerN" fields at a time
    jq_expression='.'
    for j in {1..100}; do
      ((n++))
      jq_expression+=" + {\"filler${n}\": \"dummy filler line to increase file size; you can add more text here\"}"
    done

    # Update the file by adding 100 fields
    tmpfile=$(mktemp)
    jq "$jq_expression" "$dest" > "$tmpfile" && mv "$tmpfile" "$dest"
  done
done

