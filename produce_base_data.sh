#!/bin/bash

mkdir -p base

jq -c '.["statuses"][]' twitter.json | awk '{print > ("base/object_" NR-1 ".json")}'
