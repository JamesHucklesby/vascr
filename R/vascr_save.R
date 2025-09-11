#' Title
#'
#' @param data.df 
#'
#' @returns
#' @export
#'
#' @examples
#' 
#' vascr_save(crt_1, path = "crt1")
#' 
vascr_save = function(data.df , path){
  dataframe = deparse(substitute(data.df))
  get(dataframe, envir = .GlobalEnv)
  save(list = dataframe, file = path)
}
  
#' Title
#'
#' @returns
#' @export
#'
#' @examples
vascr_load = function(path){
  load(path, envir = .GlobalEnv, verbose = TRUE)
  }

# rm(crt_1)
