#' Title
#'
#' @param aplot 
#'
#' @return
#' @export
#'
#' @examples
# ledgend = vascr_grab_legend(p1, position = "right")
# grid.arrange(vascr_grab_legend(p1, position = "top"))
# 
# ggplotGrob(ledgend)
vascr_grab_legend = function(aplot, position = "left")
{
  g <- ggplotGrob(aplot + theme(legend.position=position))$grobs
  legend <- g[[which(sapply(g, function(x) x$name) == "guide-box")]]
  return(legend)
}



#' Title
#'
#' @param donor 
#' @param recipient 
#'
#' @return
#' @export
#'
#' @examples
vascr_switch_legend = function(donor, recipient)
{
  leg = vascr_grab_legend(donor)
  rec = recipient + theme(legend.position = "none")
  
  lheight <- sum(leg$width)
  
  
  final = arrangeGrob(rec, leg, widths = unit.c(unit(1, "npc") - lheight, lheight))
  
  return(final)
}

