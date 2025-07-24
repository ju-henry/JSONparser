
args <- commandArgs(trailingOnly = TRUE)
all_objects <- list.files(paste0("./", args), pattern = "json", full.names = T)

all_files <- sapply(all_objects, function(x) paste(readLines(x), collapse = ""))

jq_query <- '[
  .created_at, 
  .user.name, 
  (.text | length), 
  .user.location, 
  (.user.description | length), 
  .user.followers_count, 
  .user.friends_count, 
  .user.verified, 
  .user.profile_use_background_image, 
  .user.lang, 
  .user.created_at, 
  .possibly_sensitive, 
  .retweeted, 
  (.entities.hashtags | length), 
  (.entities.urls | length), 
  (.entities.user_mentions | length), 
  (.entities.media | length), 
  .retweeted_status.user.name, 
  .retweeted_status.user.followers_count, 
  .retweeted_status.user.friends_count, 
  .retweeted_status.user.verified
] | @csv'

res <- jqr::jq(all_files, jq_query)

substr(res, nchar(res), nchar(res)) <- " "
substr(res, 1, 1) <- " "
res <- trimws(res)
res <- gsub('\\\\', '', res)

writeLines(text = res, con = "output_jqr.csv")
