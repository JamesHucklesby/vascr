#' Title
#'
#' @param df1 
#' @param df2 
#'
#' @return
#' @export
#'
#' @examples
create_or_merge = function(df1, df2)
{
  df1name = deparse(substitute(df1))
  
  if(!exists(df1name))
  {
    return(df2)
  }
  
  return(rbind(df1, df2))
  
}

# dataa = data.frame(num = c(1,2), let  = c("A","B"))
# datab = data.frame(num = c(3,4), let = c("C","D"))
# 
# create_or_merge(dataa, datab)
# create_or_merge(datac, datab)


#' Title
#'
#' @param df 
#'
#' @return
#' @export
#'
#' @examples
#' remove_if_exists(m)
#' 
remove_if_exists = function(df)
{
  if(exists(deparse(substitute(df))))
     {
       rm(df)
  }
}


