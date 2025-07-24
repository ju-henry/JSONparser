#!/bin/bash

# Check if results_logs.txt exists, if yes, delete it
if [ -f "results_logs.txt" ]; then
  rm "results_logs.txt"
fi

# Define arrays of scripts and arguments
scripts=("parse_jqr.R" "parse_jsonlite.R" "parse_rcppsimdjson.R")
args=("twitter" "twitter_heavier" "twitter100")

# Loop over each script and each argument
for arg in "${args[@]}"; do
  for script in "${scripts[@]}"; do
    /usr/bin/time -f"%E,%P,$script,$arg" -o results_logs.txt -a Rscript "$script" "$arg"
  done
done
