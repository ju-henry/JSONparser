import simdjson
import csv
import glob
import os
import sys

INPUT_DIR = os.path.expanduser(sys.argv[1])
OUTPUT_CSV = os.path.expanduser('output_simdjson.csv')

# List of input files
json_files = sorted(glob.glob(os.path.join(INPUT_DIR, "*.json")))

# The field extraction logic matches your jq script
def extract_fields(doc):
    def get(dct, path, default=""):
        try:
            for key in path:
                if dct is None:
                    return default
                dct = dct.get(key, default)
            return dct
        except Exception:
            return default

    # Handle None for nested objects
    user = doc.get("user", {})
    entities = doc.get("entities", {})
    retweeted_status = doc.get("retweeted_status", {})
    retweeted_user = retweeted_status.get("user", {})

    return [
        doc.get("created_at", ""),
        user.get("name", ""),
        len(doc.get("text", "")),
        user.get("location", ""),
        len(user.get("description", "")),
        user.get("followers_count", ""),
        user.get("friends_count", ""),
        user.get("verified", ""),
        user.get("profile_use_background_image", ""),
        user.get("lang", ""),
        user.get("created_at", ""),
        doc.get("possibly_sensitive", ""),
        doc.get("retweeted", ""),
        len(entities.get("hashtags", [])),
        len(entities.get("urls", [])),
        len(entities.get("user_mentions", [])),
        len(entities.get("media", [])),
        retweeted_user.get("name", ""),
        retweeted_user.get("followers_count", ""),
        retweeted_user.get("friends_count", ""),
        retweeted_user.get("verified", ""),
    ]

with open(OUTPUT_CSV, "w", newline='', encoding="utf-8") as csvfile:
    writer = csv.writer(csvfile, quoting=csv.QUOTE_MINIMAL)
    for json_path in json_files:
        parser = simdjson.Parser()
        try:
            with open(json_path, "rb") as f:
                doc = parser.parse(f.read())
            row = extract_fields(doc)
            writer.writerow(row)
        except Exception as e:
            print(f"Error in file {json_path}: {e}")

