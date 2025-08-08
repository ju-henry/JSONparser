res_files <- paste0("results_logs_", 1:5, ".csv")
read_csv_header <- function(f) {
  
  values <- read.csv(f, header = FALSE)[, 1]
  values <- sub(pattern = "^0:", "", values)
  values <- as.numeric(values)
  
  return(values)
}
A <- sapply(res_files, read_csv_header)
times <- apply(A, 1, median)

df <- read.csv(res_files[1], header=FALSE)
df$V1 <- times
df$V1 <- signif(df$V1, digits = 2)
df$V3 <- gsub(pattern = "parse_|\\.R|\\.py|\\.sh", replacement = "", x = df$V3)
names(df) <- c("time", "CPU", "tool", "case")
write.table(df, "/output/results_logs_median.csv", row.names = F, sep = ",")