

test_that("Can subset correctly", {
  
  expect_snapshot(vascr_subset(growth.df))
  
  
  # Time
  expect_snapshot(vascr_subset(growth.df, time = 40))
  expect_snapshot(vascr_subset(growth.df, time = c(40,60)))
  expect_snapshot(vascr_subset(growth.df, time = NULL))
  
  # Unit
  expect_snapshot( vascr_subset(growth.df, unit = "Rb"))
  expect_snapshot(vascr_subset(growth.df, unit = "R"))
  
  # Well
  expect_snapshot(vascr_subset(growth.df, well = "A1"))
  expect_snapshot(vascr_subset(growth.df, well = "B12"))
  expect_snapshot(vascr_subset(growth.df, well = "B20"))
  
  expect_snapshot(vascr_subset(growth.df, well = c("B2", "B03")))
  expect_snapshot(vascr_subset(growth.df, well = c("-A01", "-B3")))
  
  
  # Frequency
  expect_snapshot(vascr_subset(growth.df, frequency = 4000))
  expect_snapshot(vascr_subset(growth.df %>% mutate(Frequency = as.character(Frequency)), frequency = "4000"))
  
  # Experiment
  expect_snapshot(vascr_subset(growth.df, experiment = 1))
  expect_snapshot(vascr_subset(growth.df, experiment = 1))
  
  
  # Instrument
  expect_snapshot(vascr_subset(growth.df, instrument = "ECIS"))
  
  # Sample ID
  expect_snapshot(vascr_subset(growth.df, unit = "Rb", sampleid = c(1:3)))
  expect_snapshot(vascr_subset(growth.df, unit = "Rb", sampleid = c(8)))
  
  # Sub sample
  expect_snapshot(vascr_subset(growth.df, subsample = 100))
  
  
  # Check ignores warning when there is an issue
  expect_snapshot(vascr_subset(growth.df, unit = "Rb", sampleid = 10))
  

})