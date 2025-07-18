
all_objects <- list.files("./twitter", pattern = "json", full.names = T)
lres <- vector(mode = "list", length = length(all_objects))

for (i in seq_along(all_objects)) {
  
  a <- jsonlite::fromJSON(all_objects[i], 
                          simplifyVector = F, 
                          simplifyDataFrame = F, 
                          simplifyMatrix = F)
  
  lres[[i]] <- list(
    a[["created_at"]],
    a[["user"]][["name"]],
    nchar(a[["text"]]),
    a[["user"]][["location"]],
    nchar(a[["user"]][["description"]]),
    a[["user"]][["followers_count"]],
    a[["user"]][["friends_count"]],
    a[["user"]][["verified"]],
    a[["user"]][["profile_use_background_image"]],
    a[["user"]][["lang"]],
    a[["user"]][["created_at"]],
    a[["possibly_sensitive"]],
    a[["retweeted"]],
    length(a[["entities"]][["hashtags"]]),
    length(a[["entities"]][["urls"]]),
    length(a[["entities"]][["user_mentions"]]),
    length(a[["entities"]][["media"]]),
    a[["retweeted_status"]][["user"]][["name"]],
    a[["retweeted_status"]][["user"]][["followers_count"]],
    a[["retweeted_status"]][["user"]][["friends_count"]],
    a[["retweeted_status"]][["user"]][["verified"]]
  )  
  
  lres[[i]][sapply(lres[[i]], is.null)] <- NA

}

df <- do.call(rbind, lres)
write.table(x = df, file = "output_jsonlite.csv", 
            row.names = F, col.names = F, sep = ",")




