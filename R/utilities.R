function(){
dependancies = find_deps()

dependancies$package_used %>% table() %>%
  as.tibble() %>%
  arrange(n) %>%
  print(n = 1000)
}

mc_tribble <- function(indf, indents = 4, mdformat = TRUE) {
  name <- as.character(substitute(indf))
  name <- name[length(name)]
  
  meat <- capture.output(write.csv(indf, quote = TRUE, row.names = FALSE))
  meat <- paste0(
    paste(rep(" ", indents), collapse = ""),
    c(paste(sprintf("~%s", names(indf)), collapse = ", "),
      meat[-1]))
  
  if (mdformat) meat <- paste0("    ", meat)
  obj <- paste(name, " <- tribble(\n", paste(meat, collapse = ",\n"), ")", sep = "")
  if (mdformat) cat(paste0("    ", obj)) else cat(obj)
}