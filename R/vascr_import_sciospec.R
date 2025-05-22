#' Title
#'
#' @param cur_file 
#' @param shear 
#'
#' @returns
#' 
#' @importFrom stringr str_count
#' 
#' @noRd
#'
#' @examples
#' 
#' cur_file = system.file('extdata/instruments/ScioSpec/20250331 22.12.35\\demoexperiment1\\ECISadapter 1\\demoexperiment1_00001.spec', package = 'vascr')
#' 
#' import_sciospec_single(cur_file)
#' 
import_sciospec_single = memoise({function(cur_file, shear = FALSE){
  
  vascr_validate_file(cur_file, "spec")
  
  rlang::check_installed(c("data.table", "readr"), reason = "is needed to deal with the ScioSpec data format`")
  
  suppressMessages({
    cur_dat = data.table::fread(cur_file, showProgress = FALSE)
    meta = readr::read_lines(cur_file, n_max = 8, progress = FALSE)
    
  })
  
  
  
  cur_dat$channel = meta[[which(str_count(meta, "Channel") == 1)]]
  cur_dat$time = meta[[which((str_count(meta, "p\\.m\\.$") + str_count(meta, "a\\.m\\.$")) ==1)]]
  
 
  
  
  # cur_dat = read.csv2(cur_file, header = FALSE)
  
  #
  # meta = cur_dat[1,]
  # met = cur_dat[1:meta,]
  #
  # channel = met[6] %>% str_remove("Channel: ")
  # time    = met[7]
  #
  # first_data = (cur_dat[1,]) %>% as.numeric()
  # first_data = first_data +1
  #
  # body = cur_dat[first_data:nrow(cur_dat),] %>% as.data.frame() %>%
  #         separate(col = ".", into = c("F", "R", "I"), sep = ",")
  
  # t2 = time %>% sub(":([^:]*)$", ".\\1", .) %>% str_replace("a.m.", "am") %>% str_replace("p.m.", "pm")
  
  # livetime = strptime(t2, "%d-%B.-%Y %I:%M:%OS %p")
  
  # body = cur_dat %>% mutate(R = `Re[Ohm]`, `Re[Ohm]`  = NULL) %>%
  #   mutate(I = `Im[Ohm]`, `Im[Ohm]` = NULL) %>%
  #   mutate(Frequency = F, F = NULL) %>%
  #   pivot_longer(c("R", "I"), names_to = "Unit", values_to = "Value")
  
  
  return(cur_dat)
  
}
  
})




#' Title
#'
#' @param data_path 
#' @param shear 
#' @param nth 
#' 
#' @importFrom dplyr mutate tribble left_join select distinct
#' @importFrom tidyr pivot_longer
#' @importFrom stringr str_replace
#'
#' @returns
#' 
#' @noRd
#'
#' @examples
#' data_path = system.file('extdata/instruments/ScioSpec/', package = 'vascr')
#' import_sciospec(data_path, shear = FALSE)
#' import_sciospec(data_path, shear = TRUE)
#' 
#' data_path = "C:\\Users\\James Hucklesby\\ScioSpec\\250515 Sanity check\\20250516 14.33.47\\Day0Collagentest\\"
#' 
import_sciospec = function(data_path, shear = FALSE, experiment = NA, nth = 1){
  
  rlang::check_installed(c("purrr", "data.table", "readr"), reason = "is needed to deal with the ScioSpec data format`")
  
  # Create the list of files to import, from the master file list
  
  file_tree = list.files(data_path, recursive = TRUE, full.names = TRUE, pattern = "spec")
  
  if(length(file_tree) == 0 ){
    vascr_notify("error", "No files found in designated folder, please check link")
    
  }
  
  file_tree = file_tree[seq(1,length(file_tree), nth)]
  
  # Run the reading from disk, predominantly using paralell purrr::map
  imp = purrr::map(file_tree, import_sciospec_single, .progress = TRUE) %>% bind_rows()
  
  # Clean up times
  
  times = imp %>% select("time") %>% distinct() %>%
    mutate (Time = (time %>% 
                      str_replace("\\.-", "-") %>%
                      sub(":([^:]*)$", ".\\1", .) %>% 
                      str_replace("a.m.", "am") %>% 
                      str_replace("p.m.", "pm") %>%
                      strptime("%d-%B-%Y %I:%M:%OS %p")) %>%
              as.numeric())
  
  times
  
  # Map pins to actual physical locations, depending on the chip type
  
  scio_map = tribble(~channel, ~static, ~shear,
                     "Channel: ECISadapter 1", "D02", "F01",
                     "Channel: ECISadapter 2", "C02", "D01",
                     "Channel: ECISadapter 3", "B02", "B01",
                     "Channel: ECISadapter 4", "A02", "NC",
                     "Channel: ECISadapter 5", "A01", "NC",
                     "Channel: ECISadapter 6", "B01", "A01",
                     "Channel: ECISadapter 7", "C01", "C01",
                     "Channel: ECISadapter 8", "D01", "E01"
  )
  
  
  if(shear)
  {
    scio_map$Well = scio_map$shear
  } else {
    scio_map$Well = scio_map$static
  }
  
  scio_map = scio_map %>% select(channel, Well)
  
  # Misc cleanup to vascr interoperable fomat
  
  imp2 = imp %>% mutate(R = `Re[Ohm]`, `Re[Ohm]`  = NULL) %>%
    mutate(I = `Im[Ohm]`, `Im[Ohm]` = NULL) %>%
    mutate(Frequency = `frequency[Hz]`, `frequency[Hz]` = NULL) %>%
    pivot_longer(c("R", "I"), names_to = "Unit", values_to = "Value") %>%
    left_join(scio_map) %>%
    mutate(Instrument = "sciospec") %>%
    left_join(times) %>%
    mutate(Experiment = "TEST", Sample = .data$Well) %>%
    mutate(Time = Time - min(Time)) %>%
    mutate(Time = Time/60/60) %>%
    mutate(time = NULL) %>%
    mutate(Value = as.numeric(Value)) %>%
    mutate(SampleID = 5) %>%
    mutate(Excluded = "no") %>%
    mutate(Experiment = experiment)
  
  return(imp2)
  
  
}

