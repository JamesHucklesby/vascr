cli_text(
  "See the cli homepage at {.url https://cli.r-lib.org} for details."
)


cli_text("... see line 5 in {.file ~/.Rprofile:5}.")


filetasks = function()
{
  
devtools::load_all()

live_path = rstudioapi::getSourceEditorContext()$path %>% basename()

issues = data.frame(issue = capture.output(codetools::checkUsagePackage("vascr")))

issues$id = c(1:nrow(issues))

issues$active = stringr::str_count(issues$issue, live_path)

issue_files = stringr::str_extract(issues$issue, "\\(.*.R") %>% str_remove_all("\\(") %>% unique()

for(i in issue_files){
  cli::cli_text(paste("{.file ", i, "}", sep = ""))
}



issue_filter = issues #%>% filter(issues$active >0)

for (i in issue_filter$issue){
  
i %>% stringr::str_replace(., "\\(", "{.file ") %>% 
              stringr::str_replace(., "\\)", "}") %>%
              stringr::str_replace(., "-[0-9][0-9][0-9]\\}$", "}")%>%
              stringr::str_replace(., "-[0-9][0-9]\\}$", "}")%>%
              stringr::str_replace(., "-[0-9]\\}$", "}") %>%
              cli::cli_text()
}

}

testdat = spelling::spell_check_package() %>% unnest(found) %>% mutate(found = str_replace(found, '.Rd', ".R"))

testdat$word %>% unique()

for(i in c(1:nrow(testdat))){
  cli::cli_text(paste("{.file R/", testdat[i,]$found, "}", sep = ""))
}

r_files = list.files("R") %>% paste("R/",. , sep = "")

spells = unique(testdat$word)

for(word in spells){

for(i in r_files){
  lines = grep(word, readLines(i))
  lines2 = grep("^#'", readLines(i))
  coms = lines[lines %in% lines2]
  for(j in coms){
  cli::cli_text(glue("{word}   {{.file {i}:{j}}}", sep = ""))
  }
}
  
}




# DF = data.frame(val = 1:10, bool = TRUE, big = LETTERS[1:10],
#                 small = letters[1:10],
#                 dt = seq(from = Sys.Date(), by = "days", length.out = 10),
#                 stringsAsFactors = FALSE,
#                 test = "0_cells + HCMEC D3_line")
# 
# # try updating big to a value not in the dropdown
# rhandsontable(DF, rowHeaders = NULL, width = 550, height = 300) %>%
#   hot_col(col = "big", type = "dropdown", source = LETTERS) %>%
#   hot_col(col = "small", type = "autocomplete", source = letters,
#           strict = FALSE)
}
