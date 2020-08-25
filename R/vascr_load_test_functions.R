#' List out all the vascr functions
#'
#' @return A vector of all the exported and non-exported functions present
#'
#' @examples
#' #vascr_all_functions()
#' 
vascr_all_functions = function()
{
library("vascr", character.only = T)
all_functions <- unclass(lsf.str(envir = asNamespace("vascr"), all.names = T))
return(all_functions)
}

# #' Retrieve a function from the vascr namespace
# #'
# #' @param name Name of the funciton to retireve
# #'
# #' @return Nothing, the funciton will be loaded straight into the global enviroment
# #'
# #'@importFrom utils getFromNamespace
# #'
# #' @examples
# #' #vascr_retrieve_name("vascr_plot")
# vascr_retrieve_name = function(name)
# {
# assign(name,getFromNamespace(name, ns = "vascr"), .GlobalEnv)
# }

#' #' Load all the vascr funcitons into the global namespace
#' #'
#' #' @return Nothing, but all funcitons will be loaded into the global namespace, overwriting any temporary additions
#' #'
#' #' @examples
#' #' #vascr_load_all()
#' #' 
#' vascr_load_all = function()
#' {
#'   allfunctions = vascr_all_functions()
#'   
#'   for(fun in allfunctions)
#'   {
#'     vascr_retrieve_name(fun)
#'   }
#' }
