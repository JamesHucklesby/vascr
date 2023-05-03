#' Import impedance data to a vascr dataset
#'
#' @param instrument The instrument to import from. 
#' @param raw Path to the raw dataset. Ignored if not set
#' @param model Path to the modeled dataset. Ignored if not set
#' @param key Key file, containing data on which well contains what data
#' @param experimentname Name to assign to the experiment
#' @param password The password for protected xCELLigence files
#' 
#' @importFrom dplyr if_else
#'
#' @return A full vascr dataset
#' @export
#'
#' @examples
#' # ECIS test
#' rawdata = system.file('extdata/instruments/ecis_TimeResample.abp', package = 'vascr')
#' modeleddata = system.file('extdata/instruments/ecis_TimeResample_RbA.csv', package = 'vascr')
#' sampledefine = system.file('extdata/instruments/eciskey.csv', package = 'vascr')
#' 
#' #Then run the import
#' data1 = vascr_import("ECIS", model = modeleddata, key = sampledefine, experimentname = "TEST1")
#' data2 = vascr_import("ECIS", raw = rawdata, key = sampledefine, experimentname = "TEST2")
#' data3 = vascr_import("ECIS",model = modeleddata, raw = rawdata, 
#' key = sampledefine, experimentname = "TEST3")
#' 
#' # cellZscope test
#' rawdata = system.file('extdata/instruments/zscoperaw.txt', package = 'vascr')
#' modeleddata = system.file('extdata/instruments/zscopemodel.txt', package = 'vascr')
#' sampledefine = system.file('extdata/instruments/zscopekey.csv', package = 'vascr')
#' 
#' data4 = vascr_import("cellZscope", model = modeleddata, key = sampledefine, 
#' experimentname = "TEST4")
#' data5 = vascr_import("cellZscope", raw = rawdata, key = sampledefine, experimentname = "TEST5")
#' data6 = vascr_import("cellZscope",model = modeleddata, raw = rawdata, 
#' key = sampledefine, experimentname = "TEST6")
#' 
#' # xCELLigence test
#' rawdata = system.file('extdata/instruments/xcell.plt', package = 'vascr')
#' sampledefine = system.file('extdata/instruments/xcellkey.csv', package = 'vascr')
#' 
# data7 = vascr_import("xCELLigence", raw = rawdata, key = sampledefine, experimentname = "TEST7")
# 
# masterdata = vascr_combine(data3, data6, data7)
# masterdata = vascr_resample(masterdata, 1)
#
vascr_import = function(instrument, raw = NULL, model = NULL, key = NULL, experimentname = "NA", password = "RTCaDaTa")
{
  inst = vascr_match(instrument, vascr_instrument_list())
  
  if(vascr_all_null(raw, model))
  {
    stop("Either raw or modeled data must be set, please set one and run the function again")
  }
  
  if(inst == "ECIS")
  {
    if(!is.null(raw) & !is.null(model))
    {
      data.df = ecis_import(raw, model, key, experimentname)
      return(data.df)
    }
    else if(!is.null(raw))
    {
      data.df = ecis_import_raw(raw, key, experimentname)
      return(data.df)
       
    }else if(!is.null(model))
    {
      data.df = ecis_import_model(model, key, experimentname)
      return(data.df)
    }
    
    
  }else if (inst == "cellZscope")
  {
    
    if(!is.null(raw) & !is.null(model))
    {
      data.df = cellzscope_import(raw, model, key, experimentname)
      return(data.df)
    }
    else if(!is.null(raw))
    {
      data.df = cellzscope_import_raw(raw, key, experimentname)
      return(data.df)
      
    }else if(!is.null(model))
    {
      data.df = cellzscope_import_model(model, key, experimentname)
      return(data.df)
    }
    
    
  }else if(inst == "xCELLigence")
  {
    
    data.df = import_xcelligence(raw, key, experimentname, password)
    return(data.df)
    
  }
  else
  {
    stop("Instrument not found, please correct and try again")
  }
  
}
