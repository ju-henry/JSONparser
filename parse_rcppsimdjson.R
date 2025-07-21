
all_objects <- list.files("./twitter100", pattern = "json", full.names = T)

lres <- RcppSimdJson::fload(
   json = all_objects, 
   query = c("/created_at", 
             "/user/name",
             "/text",
             "/user/location",
             "/user/description",
             "/user/followers_count",
             "/user/friends_count",
             "/user/verified",
             "/user/profile_use_background_image",
             "/user/lang",
             "/user/created_at",
             "/possibly_sensitive",
             "/retweeted",
             "/entities/hastags",
             "/entities/urls",
             "/entities/user_mentions",
             "/entities/media",
             "/retweeted_status/user/name",
             "/retweeted_status/user/followers_count",
             "/retweeted_status/user/friends_count",
             "/retweeted_status/user/verified"), 
   query_error_ok = T, 
   on_query_error = NA, 
   max_simplify_lvl = 3L)

for (i in 1:length(lres)) {

  lres[[i]][c(3, 5)] <- lapply(lres[[i]][c(3, 5)], nchar)
  lres[[i]][14:17] <- lapply(lres[[i]][14:17], length)

}

df <- do.call(rbind, lres)
write.table(x = df, file = "output_rcppsimdjson.csv",
            row.names = F, col.names = F, sep = ",")

