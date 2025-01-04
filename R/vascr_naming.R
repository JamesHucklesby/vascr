#' Import a vascr platemap
#'
#' @param file_content a tibble or file path to import
#'
#' @return the imported plate map, fully lengthened to remove duplication
#' 
#' @importFrom dplyr cur_group_id mutate ungroup
#' @importFrom tidyr separate_rows
#' 
#' @noRd
#' 
#' @importFrom tidyr separate_rows
#' @importFrom dplyr relocate group_by_all
#'
#' @examples
#'map_1 = tribble(~Row, ~Column, ~Sample,
#'                "A", "1 2 3", "10 nM Treatment 1 + 1nm water",
#'                "B", "1 2 3", "100 nM Treatment 1 + 1nm water",
#'                "C", "4 5 6", "10 nM Treatment 2 + 1nm water",
#'              "D", "1 2 3", "100 nM Treatment 2 + 1nm water")
#'              
#'vascr_import_map(map_1)
#'
#'lookup = tribble(~Row, ~Column, ~Sample,
#'           "A B C D E F G H", "2", "NZB11 + Media")
#'           
#'vascr_import_map(lookup)
#'
#'lookup = system.file('extdata/instruments/eciskey.csv', package = 'vascr')
#'lookupmap = vascr_import_map(lookup)
#'
#'map.df =vascr_import_map(lookup = "ECIS/200722_key.csv")
#'
vascr_import_map = function(lookup) {
  
  if(is.character(lookup))
  {
    file_content = read.csv(lookup)
  } else
  {
    file_content = lookup
  }
  
  # Check for duplicate sample names
  # vascr_check_duplicate(file_content, "Sample")
  
  # Add a Sample ID automatically if not already set
  if(!"SampleID" %in% colnames(file_content)) {
    file_content = file_content %>% group_by_all() %>% mutate(SampleID = cur_group_id())
  } else { # If samples are set, check for duplicate ID rows
    vascr_check_duplicate(file_content, "SampleID")
  }
  
  # Lengthen out imported names
  if("Well" %in% colnames(file_content)) {
    file_map = file_content %>%
      separate_rows("Well", sep = " ") %>%
      mutate(Well = vascr_standardise_wells(.data$Well))
  }else if("Row" %in% colnames(file_content) & "Column" %in% colnames(file_content)){
    file_map = file_content %>% 
      mutate(Row = trimws(.data$Row), Column = trimws(.data$Column)) %>%
      separate_rows("Row", sep = " ") %>%
      separate_rows("Column", sep = " ") %>%
      mutate(Well = paste(.data$Row, .data$Column, sep = ""), Well = vascr_standardise_wells(.data$Well)) %>%
      mutate(Row = NULL, Column = NULL)
  }else {
    stop("Either `Row` and `Column' or `Well` must be specified in the input file")
  }
  
  vascr_check_duplicate(file_map, "Well") # Check if each well is defined more than once
  
  if(!"Sample" %in% colnames(file_map))
  {
    file_map = vascr_implode(file_map)
  }
  
  file_map = ungroup(file_map)
  
  return(file_map)
}


#' Apply a map to a vascr dataset
#'
#' @param data.df the dataset to apply to
#' @param map the dataset to apply
#'
#' @return a named vascr dataset
#' 
#' @noRd
#'
#' @examples
#' lookup = system.file('extdata/instruments/eciskey.csv', package = 'vascr')
#' vascr_apply_map(growth.df, lookup)
#' 
vascr_apply_map = function(data.df, map){
  
  map.df = vascr_import_map(map)
  
  data.df %>% left_join(map.df)
  
}


#' Implode individual samples from a vascr dataset
#'
#' @return A vascr dataset with individual wells imploded
#' @export
#' 
#' @importFrom dplyr bind_rows
#' @importFrom foreach foreach `%do%`
#'
#' @examples
#' vascr_implode(growth.df)
#' 
vascr_implode = function(data.df){
  
  toimplodetf = !colnames(data.df) %in% c("Time", "Well", "Unit", "Value", "Instrument", "Experiment", "Frequency", "SampleID", "Sample")
  toimplode = subset(colnames(data.df), toimplodetf)
  
  smallframe = data.df %>% select(all_of(toimplode), "SampleID") %>%
    distinct()
  
  to_merge = toimplode
  
  smallframe
  
  r = 0
  
  names = foreach(r = c(1:nrow(smallframe))) %do%
    {
      row = smallframe[r,]
        all_cols = foreach (c = to_merge) %do%
        {
          if(!as.character(row[,c]) %in% c("NA")){
           paste(row[,c], c)
          }
        }
        row$Sample = paste(unlist(all_cols), collapse = " + ")
        return(row)
    }
  
  newnames = bind_rows(names)
  
  if("Sample" %in% colnames(data.df))
  {
    data.df = data.df %>% select(-"Sample")
  }
  
  newnames %>%
    ungroup() %>%
    select("SampleID", "Sample") %>%
    left_join(data.df, by = "SampleID")
  
}


#' Separate names in a vascr plate map
#'
#' @param data.df the dataset to separate
#'
#' @return a separated vascr dataset, with additional columns for each variable
#' 
#' @importFrom dplyr select distinct mutate left_join join_by
#' @importFrom tidyr separate_longer_delim separate_wider_delim pivot_wider
#' @importFrom stringr regex
#' 
#' @export
#'
#' @examples
#' vascr_explode(growth.df)
vascr_explode = function(data.df) {
  
# Check an appropriate data set has been created
  vascr_check_col_exists(data.df, "SampleID")
  vascr_check_col_exists(data.df, "Sample")
  
# Break out the data
  distinct_samples = data.df %>%
  select("SampleID", "Sample") %>%
  distinct() 

# Check there isn't duplication in Sample or SampleID pairs as this may muck things up later
  vascr_check_duplicate(distinct_samples, "SampleID")
  vascr_check_duplicate(distinct_samples, "Sample")

# Generate the expanded cols, based on SampleID as the unique key
samples = distinct_samples %>%
  separate_longer_delim("Sample", " + ") %>%
  separate_wider_delim("Sample", delim = regex("(_| )"), names = c("value", "name"), too_many = "merge", cols_remove = FALSE) %>%
  mutate(name = trimws(.data$name)) %>%
  distinct() %>%
  pivot_wider(names_from = "name", id_cols = "SampleID") %>%
  mutate(`NA` = NULL)

# Attach the full data set back onto the data frame
  fulldata = data.df %>% left_join(samples, by = join_by("SampleID"))

return(fulldata)

}
