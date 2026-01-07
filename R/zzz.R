

#' Memoise key functions to speed up code execution
#' 
#' @importFrom memoise memoise
#' @noRd
#'
.onLoad <- function(libname, pkgname) {
  vascr_subset <<- memoise::memoise(vascr_subset)
}