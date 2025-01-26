cli_text(
  "See the cli homepage at {.url https://cli.r-lib.org} for details."
)


cli_text("... see line 5 in {.file ~/.Rprofile:5}.")


issues = capture.output(codetools::checkUsagePackage("vascr"))

for (i in c(1:length(issues))){
  
issues[[i]] %>% stringr::str_replace(., "\\(", "{.file ") %>% 
              stringr::str_replace(., "\\)", "}") %>%
              stringr::str_replace(., "-[0-9][0-9][0-9]\\}$", "}")%>%
              stringr::str_replace(., "-[0-9][0-9]\\}$", "}")%>%
              stringr::str_replace(., "-[0-9]\\}$", "}") %>%
              cli_text()
}



