#' Validate a file
#' 
#' Validates if a file exists, and if it has the correct file extension. This is used at the start of all import files to allow them to fail fast, rather than running intensive computations on files that are not found. Also prevents the generation of cryptic errors from downstream functions, that fail due to being presented with data in a strange format.
#'
#' @param file_name Character string specifying the file name
#' @param extension Character string containing a file extension that will be matched against the file type of file_name. Case insensitive.
#'
#' @return TRUE if it passes, FALSE if it does not. Also spits out warnings that will help the user correct the error
#' @export
#'
#' @examples
#' # check a file that does not exist fails
#' #vascr_validate_file("R/AAA_TODOOO.R", "P")
#' # Check a file with the wrong extension fails
#' #vascr_validate_file("R/AAA_TODO.R", "P")
#' # Check a file with the wrong extensions fail
#' #vascr_validate_file("R/AAA_TODO.R", c("P", "q"))
#' # Check a file with the right extension passes
#' #vascr_validate_file("R/AAA_TODO.R", "R")
#' # Check a file with one of two right extensions passes
#' #vascr_validate_file("R/AAA_TODO.R", extension = c("p", "r"))

vascr_validate_file = function(file_name, extension)
{

  if(!(isTRUE(file.exists(file_name))))
   {
       stop(paste("File ", file_name,"  not found. Please check file path and try again"))
    exists = FALSE
  }
  else
  {
    exists = TRUE
  }
  
  ## Check for the correct file extension
  
  if(!missing(extension))
  {
    
  # If file extension is specified, check it matches
  
  split_name <- strsplit(basename(file_name), split="\\.")[[1]]
  file_extension = split_name[-1]
  
  extensioncorrect = any(toupper(file_extension) %in% toupper(extension))
  
  if(extensioncorrect)
  {
    correct = TRUE
  }
  else
  {
    filetypes = paste(extension, collapse = " or ")
    
    stop(paste("File extension is", file_extension, "not the required extension(s) ",filetypes,". Please check you have the correct file in the correct argument and try again."))
    correct = FALSE
  }
  
  }
  else
  {
    # If no file extension to check was given, return false
    correct = TRUE
  }
  
  # Return true if all conditions are met
  return(all(exists,correct))
}



