
#' Reinstalls the package from GitHub. Temporary.
#' 
#' 
#'
#' @return Installs all the git requisites for the package. Not yet available via CRAN.
#' 
#' @export
#'
#' @examples
#' 
#' #install_git_requirements()
#' 
reinstall_updates = function() {
    
    # This gives a private token to view my repostories
    devtools::install_github("JamesHucklesby/ECIS-R", auth_token = "b8b71100e6dfcb467c3777abacafbccd0dbfec94", 
        ref = "master")
}


# Count how many lines are in this package, cos

# library(dplyr)
# library(stringr)
# # Count your lines of R code
# list.files(path = "/Users/jhuc964/Desktop/ECIS R/ECISR/R", recursive = T, full.names = T) %>%
#   str_subset("[.][R]$") %>%
#   sapply(function(x) x %>% readLines() %>% length()) %>%
#   sum()
