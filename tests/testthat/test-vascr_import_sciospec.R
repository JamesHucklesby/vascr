test_that("Check col exists", {

   cur_file = system.file('extdata/instruments/ScioSpec/20250331 22.12.35\\demoexperiment1\\ECISadapter 1\\demoexperiment1_00001.spec', package = 'vascr')
  expect_snapshot(import_sciospec_single(cur_file))
  
  data_path = system.file('extdata/instruments/ScioSpec/', package = 'vascr')
  
  expect_snapshot(import_sciospec(data_path))
  expect_snapshot(import_sciospec(data_path, shear = TRUE))
  
  
  
})
