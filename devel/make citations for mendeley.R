c1 = "cli,
dplyr,
foreach,
ggnewscale,
ggplot2,
ggpubr,
progressr,
doFuture,
ggtext,
glue,
memoise,
furrr,
multcomp,
patchwork,
rlang,
rstatix,
stringr,
tidyr,
utils,
ggrepel,
nlme,
bslib,
DBI,
DT,
future,
odbc,
readr,
readxl,
shiny,
shinyjs,
testthat,
vdiffr,
writexl"

t1 = tibble(string = c1) %>% separate_longer_delim(cols = string, delim = ",\n")


foreach(t = t1$string) %do% {
  print(toBibtex(citation(t)))
}

