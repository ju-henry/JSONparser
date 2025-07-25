library(jqr)

args <- commandArgs(trailingOnly = TRUE)
input_dir <- paste0("./", args)
all_files <- list.files(input_dir, pattern = "json", full.names = TRUE)

jq_query <- paste0(
  "[",
  ".created_at,",
  ".user.name,",
  "(.text | length),",
  ".user.location,",
  "(.user.description | length),",
  ".user.followers_count,",
  ".user.friends_count,",
  ".user.verified,",
  ".user.profile_use_background_image,",
  ".user.lang,",
  ".user.created_at,",
  ".possibly_sensitive,",
  ".retweeted,",
  "(.entities.hashtags | length),",
  "(.entities.urls | length),",
  "(.entities.user_mentions | length),",
  "(.entities.media | length),",
  ".retweeted_status.user.name,",
  ".retweeted_status.user.followers_count,",
  ".retweeted_status.user.friends_count,",
  ".retweeted_status.user.verified",
  "] | @csv"
)

jq_query <- paste0('select(',
                   '.[0] == ["created_at"] or',
                   '.[0] == ["user","name"] or',
                   '.[0] == ["text"] or',
                   '.[0] == ["retweeted_status","user","name"])',
                   ' | {key: (if (.[0]|length)==1 then .[0][0] else (.[0]|join(".")) end),',
                   'value: .[1]}')

output_lines <- character(0)

for (f in all_files) {
  # Lire le fichier ligne par ligne
  lines <- readLines(f)
  
  # Appliquer jq en streaming sur chaque ligne
  # Note : on passe tout le vecteur, mode streaming activé
  res <- jqr::jq(lines, jq_query, flags = jq_flags(stream = TRUE))
  
  lres <- as.list(jqr::jq(res, ".value"))
  names(lres) <- as.character(jqr::jq(res, ".key"))
  

}
