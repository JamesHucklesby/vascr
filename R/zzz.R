


vascr_import_memcache = function(...)
{
  
  vascr_import(...)
  
}


#' 
#' #' Memoise key functions to speed up code execution
#' #' 
#' #' @importFrom memoise memoise
#' #' @noRd
#' #'
#' .onLoad <- function(libname, pkgname) {
#'   vascr_subset <<- memoise::memoise(vascr_subset)
#'   vascr_find_unit <<- memoise::memoise(vascr_find_unit)
#'   vascr_units_table <<- memoise::memoise(vascr_units_table)
#'   vascr_titles <<- memoise::memoise(vascr_titles)
#'   
#' 
#'   
#'   vascr_import <<- memoise::memoise(vascr_import, cache = tools::md5sum("path/to/your/file.txt"))
#'   # vascr_apply_map <<- memoise::memoise(vascr_apply_map)
#' }
#' 
#' read_file = readlines()
#' 
#' rem = function(testpath, memtime = file.info("README.md")$mtime){
#'   return(memtime)
#' }
#' 
#' 
