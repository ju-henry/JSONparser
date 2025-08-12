#!/bin/bash

# Check if results_logs.txt exists, if yes, delete it
for i in $(seq 1 5); do
  if [ -f "results_logs_${i}.csv" ]; then
    rm "results_logs_${i}.csv"
  fi
done

# Define arrays of scripts and arguments
scripts=("parse_jqr.R" "parse_jsonlite.R" "parse_rcppsimdjson.R")
args=("base" "heavy" "many")

for i in $(seq 1 5); do
  # Loop over each script and each argument
  for arg in "${args[@]}"; do
    for script in "${scripts[@]}"; do
      /usr/bin/time -f"%E,$script,$arg" -o results_logs_${i}.csv -a Rscript "$script" "$arg"
    done
  done

  pyscript="parse_pysimdjson.py"
  for arg in "${args[@]}"; do
    /usr/bin/time -f"%E,$pyscript,$arg" -o results_logs_${i}.csv -a python3 "$pyscript" "$arg"
  done
  bscript="parse_jq.sh"
  for arg in "${args[@]}"; do
    /usr/bin/time -f"%E,$bscript,$arg" -o results_logs_${i}.csv -a bash "$bscript" "$arg"
  done
done
