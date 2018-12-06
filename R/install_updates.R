
#' Title
#'
#' @return
#' @export
#'
#' @examples
install_git_requirements = function()
{
# Install two pre-cran packages
devtools::install_github('thomasp85/gganimate')
devtools::install_github("thomasp85/transformr")

#This gives a private token to view my repostories
devtools::install_github("JamesHucklesby/ECIS-R", auth_token = "b8b71100e6dfcb467c3777abacafbccd0dbfec94")
}