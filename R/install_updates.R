utils::globalVariables("Unit")
utils::globalVariables("%>%")
utils::globalVariables("Well")
utils::globalVariables("Sample")
utils::globalVariables("Frequency")
utils::globalVariables("Experiment")
utils::globalVariables("Time")
utils::globalVariables("Value")


#' Reinstalls the package from GitHub. Temporary.
#'
#' @return Installs all the git requisites for the package. Not available via CRAN.
#' 
#' @export
#'
#' @examples
#' 
#' #install_git_requirements()
#' 
reinstall_updates = function()
{

#This gives a private token to view my repostories
devtools::install_github("JamesHucklesby/ECIS-R", auth_token = "b8b71100e6dfcb467c3777abacafbccd0dbfec94", ref = "deployment")
}