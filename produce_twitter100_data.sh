#!/bin/bash

# Ensure the output directory exists
mkdir -p twitter100

# Outer loop: iterate over i (0 to 99)
for i in {0..99}; do
  # Inner loop: iterate over j (0 to 99)
  for j in {0..99}; do
    # Define the source and destination paths
    src="twitter/object_${i}.json"
    dest="twitter100/object_${i}_${j}.json"
    # Copy the file
    cp "$src" "$dest"
  done
done

