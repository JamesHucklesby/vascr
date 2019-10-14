
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
