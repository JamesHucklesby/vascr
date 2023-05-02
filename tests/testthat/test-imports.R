
test_that("xCELLigence imports OK", {
  # xCELLigence test
  rawdata = system.file('extdata/instruments/xcell.plt', package = 'vascr')
  sampledefine = system.file('extdata/instruments/xcellkey.csv', package = 'vascr')

  xcell = import_xcelligence(file = rawdata, key = sampledefine, "TEST7")
  
  expect_snapshot(xcell)

  
})

test_that("ECIS imports OK", {

  rawdata = system.file('extdata/instruments/ecis_TimeResample.abp', package = 'vascr')
  sampledefine = system.file('extdata/instruments/eciskey.csv', package = 'vascr')
  
  ecis = ecis_import_raw(rawdata, sampledefine, "TEST")
  
  expect_snapshot(ecis)

})

test_that("cellZScope imports OK", {
  
  model = system.file("extdata/instruments/zscopemodel.txt", package = "vascr")
  raw = system.file("extdata/instruments/zscoperaw.txt", package = "vascr")
  key = system.file("extdata/instruments/zscopekey.csv", package = "vascr")
   
  czs = cellzscope_import(raw, model, key, "TEST")

  expect_snapshot(czs)
  
  
})
