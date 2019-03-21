
#' Title
#'
#' @return Installs all the git requisites for the package. Not available via CRAN.
#' 
#' @export
#'
#' @examples
#' 
#' install_git_requirements()
#' 
install_git_requirements = function()
{
  
install.packages("devtools")
  
# Install two pre-cran packages that run the animation stuff
devtools::install_github('thomasp85/gganimate')
devtools::install_github("thomasp85/transformr")

#This gives a private token to view my repostories
devtools::install_github("JamesHucklesby/ECIS-R", auth_token = "b8b71100e6dfcb467c3777abacafbccd0dbfec94")
}