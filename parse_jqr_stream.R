library(jqr)

args <- commandArgs(trailingOnly = TRUE)
input_dir <- paste0("./", args)
all_files <- list.files(input_dir, pattern = "json", full.names = TRUE)

jq_query <- paste0('select(',
                   '.[0] == ["created_at"] or',
                   '.[0] == ["user","name"] or',
                   '.[0] == ["text"] or',
                   '.[0] == ["user","location"] or',
                   '.[0] == ["user","description"] or',
                   '.[0] == ["user","followers_count"] or',
                   '.[0] == ["user","friends_count"] or',
                   '.[0] == ["user","verified"] or',
                   '.[0] == ["user","profile_use_background_image"] or',
                   '.[0] == ["user","lang"] or',
                   '.[0] == ["user","created_at"] or',
                   '.[0] == ["possibly_sensitive"] or',
                   '.[0] == ["retweeted"] or',
                   '.[0] == ["entities","hashtags"] or',
                   '.[0] == ["entities","urls"] or',
                   '.[0] == ["entities","user.mentions"] or',
                   '.[0] == ["entities","media"] or',
                   '.[0] == ["retweeted_status","user","name"] or',
                   '.[0] == ["retweeted_status","user","followers_count"] or',
                   '.[0] == ["retweeted_status","user","friends_count"] or',
                   '.[0] == ["retweeted_status","user","verified"])',
                   ' | ',
                   '{',
                   'key: (if (.[0]|length)==1 then .[0][0] else (.[0]|join(".")) end),',
                   'value: .[1]',
                   '}',
                   ' | ',
                   'if ',
                   '.key == "text" or ',
                   '.key == "user.description" or ',
                   '.key == "entities.urls" or ',
                   '.key == "entities.hashtags" or ', 
                   '.key == "entities.user_mentions" or ',
                   '.key == "entities.media" ',
                   'then {key: .key, value: (.value | length)} ',
                   'end')

output_lines <- character(length(all_files))

i <- 1
for (f in all_files) {
  # Lire le fichier ligne par ligne
  lines <- readLines(f)
  
  # Appliquer jq en streaming sur chaque ligne
  # Note : on passe tout le vecteur, mode streaming activé
  res <- jqr::jq(lines, jq_query, flags = jq_flags(stream = TRUE))
  
  lres0 <- list(
    "created_at" = character(), 
    "user.name" = character(), 
    "text" = integer(), 
    "user.location" = character(), 
    "user.description" = character(), 
    "user.followers_count" = integer(), 
    "user.friends_count" = integer(), 
    "user.verified" = logical(), 
    "user.profile_use_background_image" = logical(), 
    "user.lang" = character(), 
    "user.created_at" = character(), 
    "possibly_sensitive" = logical(), 
    "retweeted" = logical(), 
    "entities.hashtags" = integer(), 
    "entities.urls" = integer(), 
    "entities.user_mentions" = integer(), 
    "entities.media" = integer(), 
    "retweeted_status.user.name" = character(), 
    "retweeted_status.user.followers_count" = integer(), 
    "retweeted_status.user.friends_count" = integer(), 
    "retweeted_status.user.verified" = logical()
  )
  
  lres <- as.list(jqr::jq(res, ".value"))
  lnames <- as.character(jqr::jq(res, ".key"))
  lnames <- substr(lnames, 2, nchar(lnames) - 1)
  names(lres) <- lnames
  
  for (nn in names(lres0)) {
    if (nn %in% names(lres)) {
      lres0[[nn]] <- as(lres[[nn]], class(lres0[[nn]]))
    }
  } 
  
  line_res <- paste(lres0, collapse = ",")
  line_res <- gsub("integer\\(0\\)|logical\\(0\\)", "", line_res)
  line_res <- gsub("character\\(0\\)", '\"\"', line_res)
  
  output_lines[i] <- line_res
  i <- i + 1
  
}

writeLines(text = output_lines, con = "output_jqr_stream.csv")
