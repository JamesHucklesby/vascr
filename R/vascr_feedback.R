#' Title
#'
#' @returns
#' @export
#'
#' @examples
vascr_feedback = function(type, note)
{
  if(shiny::isRunning())
  {
    showNotification(note, type = type)
  }
  
    cli_inform(note)
  
}