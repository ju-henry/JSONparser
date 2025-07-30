#!/bin/bash

SOURCE_DIR="base"     
TARGET_DIR="many"

mkdir -p "$TARGET_DIR"

for i in $(seq 0 99); do
  FILE="object_${i}.json"
  filesize=$(stat --format=%s "$SOURCE_DIR/$FILE")
  total_size=0
  j=0
  # Copier autant de fois que nécessaire pour atteindre 1 Mo
  while [[ $total_size -lt 1048576 ]]; do
    cp "$SOURCE_DIR/$FILE" "$TARGET_DIR/object_${i}_${j}.json"
    total_size=$((total_size + filesize))
    j=$((j + 1))
  done
done

