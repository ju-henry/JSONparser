#!/bin/bash

mkdir -p twitter2

jq -c '.["statuses"][]' twitter.json | awk '{print > ("twitter2/object_" NR-1 ".json")}'
