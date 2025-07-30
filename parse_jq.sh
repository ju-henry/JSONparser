#!/bin/bash

jq -r '[
.created_at, 
.user.name, 
(.text | length), 
.user.location, 
(.user.description | length), 
.user.followers_count, 
.user.friends_count, 
.user.verified, 
.user.profile_use_background_image, 
.user.lang, .user.created_at, 
.possibly_sensitive, .retweeted, 
(.entities.hashtags | length), 
(.entities.urls | length), 
(.entities.user_mentions | length), 
(.entities.media | length), 
.retweeted_status.user.name, 
.retweeted_status.user.followers_count, 
.retweeted_status.user.friends_count, 
.retweeted_status.user.verified
] | @csv' ./"$1"/*.json > output_jq.csv

