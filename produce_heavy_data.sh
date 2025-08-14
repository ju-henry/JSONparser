#!/bin/bash
mkdir -p heavy
RANDOM=42 

for file in base/*.json; do
    base=$(basename "$file")

    tmpfile=$(mktemp)

    # Store original file (JSON object)
    orig_json=$(jq '.' "$file")

    # First writing : initial file with suffix "1"
    jq --arg i "1" \
       'with_entries({key: (.key + $i), value: .value})' \
       <<< "$orig_json" > "$tmpfile"

    iter=2

    # Get sizes
    base_size=$(stat -c "%s" "$file")
    current_size=$(stat -c "%s" "$tmpfile")

    # Estimation of the nb of iterations to get to 1MB
    est_loops=$(( 1048576 / base_size ))
    min_iters=3
    rand_iter=$(( RANDOM % (est_loops - min_iters + 1) + min_iters ))

    while [ "$current_size" -lt 1048576 ] || [ "$iter" -le "$rand_iter" ]; do
        if [ "$iter" -eq "$rand_iter" ]; then
            # Add original keys
            jq --argjson orig "$orig_json" '. + $orig' "$tmpfile" > "${tmpfile}.new"
        else
            # Add keys with suffix $iter
	    jq --argjson orig "$orig_json" \
	       --arg i "$iter" \
	       '. + ($orig | with_entries({key: (.key + $i), value: .value}))' \
	       "$tmpfile" > "${tmpfile}.new"
        fi

        mv "${tmpfile}.new" "$tmpfile"
        ((iter++))
        current_size=$(stat -c "%s" "$tmpfile")
    done

    mv "$tmpfile" "heavy/$base"
done

