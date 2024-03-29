
test_that("vascr_standardise_wells works", {
  expect_equal(vascr_standardise_wells('A01'), "A01")
  expect_equal(vascr_standardise_wells('A 1'), "A01")
  expect_equal(vascr_standardise_wells('a-1'), "A01")
  expect_equal(vascr_standardise_wells('#   A#1-?!#  #-'), "A01")
  expect_equal(vascr_standardise_wells('#   Z#1-?!#  #-'), "NA")
})

test_that("vascr_find_time works",
 {
   expect_snapshot_warning(vascr_find_time(growth.df, 46.234))
   expect_snapshot_warning(vascr_find_time(growth.df, 101.233))
})