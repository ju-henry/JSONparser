#!/bin/bash

mkdir -p twitter_heavier

for file in twitter/*.json; do
    base=$(basename "$file")
    tmpfile=$(mktemp)
    cp "$file" "$tmpfile"

    iter=2
    size=$(stat -c "%s" "$tmpfile")
    while [ "$size" -lt 1048576 ]; do # 1MB = 1024 * 1024 = 1048576 bytes
        # Generate new entries with incremented suffixes
        jq --argjson orig "$(jq '.' "$file")" \
           --arg i "$iter" '
           . + (with_entries({key: (.key + $i), value: .value}))
           ' "$tmpfile" > "${tmpfile}.new"

        mv "${tmpfile}.new" "$tmpfile"
        ((iter++))
        size=$(stat -c "%s" "$tmpfile")
    done

    mv "$tmpfile" "twitter_heavier/$base"
done

