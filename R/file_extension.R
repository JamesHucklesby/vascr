#' Validate a file
#' 
#' Validates if a file exists, and if it has the correct file extension. 
#'
#' @param file_name Character string specifying the file name
#' @param extension Character string containing a file extension that will be matched against the file type of file_name
#'
#' @return TRUE if it passes, FALSE if it does not. Also spits out warnings that will help the user correct the error
#' @export
#'
#' @examples
#' ecis_validate_file("R/AAA_TODOOO.R", "P")
#' ecis_validate_file("R/AAA_TODO.R", "P")
#' ecis_validate_file("R/AAA_TODO.R", "R")

ecis_validate_file = function(file_name, extension)
{

  if(!(isTRUE(file.exists(file_name))))
   {
       warning(paste("File ", file_name,"  not found. Please check file path and try again"))
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
  
  if(extension == file_extension)
  {
    correct = TRUE
  }
  else
  {
    warning(paste("File extension is", file_extension, "not the required", extension,". Please check you have the correct file in the correct argument and try again."))
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




