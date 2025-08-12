res_files <- paste0("results_logs_", 1:5, ".csv")

get_seconds <- function(x) sum(c(3600, 60, 1)[(3 -length(x) + 1):3] * as.numeric(x))

read_csv_header <- function(f) {
  
  values <- read.csv(f, header = FALSE)[, 1]
  values <- strsplit(x = values, split = ":", fixed = TRUE)
  values <- sapply(values, get_seconds)

  return(values)
}
A <- sapply(res_files, read_csv_header)
times <- apply(A, 1, median)

df <- read.csv(res_files[1], header=FALSE)
df$V1 <- times
df$V1 <- signif(df$V1, digits = 2)
df$V2 <- gsub(pattern = "parse_|\\.R|\\.py|\\.sh", replacement = "", x = df$V2)
names(df) <- c("time", "tool", "case")
write.table(df, "/output/results_logs_median.csv", row.names = F, sep = ",")