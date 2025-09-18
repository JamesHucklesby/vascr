test_that("Find varous things", {
  
  standard = growth.df %>% vascr_subset(unit = "R", frequency = 4000, time = c(5,100))
  normal = vascr_normalise(standard, 100)
  
  expect_snapshot(vascr_find_normalised(standard))
  expect_snapshot(vascr_find_normalised(normal))
  
  
})

test_that("Force median", {
  
expect_snapshot(vascr:::vascr_force_median(c(1,3,5,6), "up"))
expect_snapshot(vascr:::vascr_force_median(c(1,3,5,6), "down"))


})


test_that("Vascr match", {
  
  vector = vascr_find_unit(growth.df, "all")
  
  expect_snapshot(vascr_match("Re", vector))
  expect_snapshot(vascr_match("Rb", vector))
  expect_snapshot(vascr_match(c("Rb", "Cm"), vector))
  
})

test_that("vascr_find_single_time", {

  expect_snapshot(vascr_find_single_time(growth.df, NULL)) # Null input error check
  expect_snapshot(vascr_find_single_time(growth.df, c(1,3))) # Two time points error check
  expect_snapshot(vascr_find_single_time(c(1,2,3), c(1,3))) # No input Df error check
  
  expect_snapshot(vascr_find_single_time(growth.df, c(4.876))) # Correct a made up time
  

})

test_that("vascr_find_well", {

  expect_snapshot(vascr_find_well(growth.df, NULL))
  expect_snapshot(vascr_find_well(growth.df, "A01"))
  expect_snapshot(vascr_find_well(growth.df, "A1"))
  expect_snapshot(vascr_find_well(growth.df, "W39"))

})

test_that("vascr_find_time", {

  expect_snapshot(vascr_find_time(growth.df, NULL))
  expect_snapshot(vascr_find_time(growth.df, list(1,3,5)))
  expect_snapshot(vascr_find_time(growth.df, Inf))
  expect_snapshot(vascr_find_time(growth.df, c(10,20)))
  expect_snapshot(vascr_find_time(growth.df, 5))
  expect_snapshot(vascr_find_time(growth.df, NA))
  
  expect_error(vascr_find_time(1,5))
  
})


test_that("vascr_find_frequency", {

  expect_snapshot(vascr_find_frequency(growth.df, 4382))
  expect_snapshot(vascr_find_frequency(growth.df, 4000))
  expect_snapshot(vascr_find_frequency(growth.df, NULL))
  expect_snapshot(vascr_find_frequency(growth.df, NA))
  expect_snapshot(vascr_find_frequency(growth.df, Inf))
  
  expect_snapshot(vascr_find_frequency(growth.df, "raw"))
  expect_snapshot(vascr_find_frequency(growth.df, "model"))

})


test_that("vascr_instrument_list", {
  
  expect_snapshot(vascr_instrument_list())
  
})

test_that("vascr_units_table", {
  
  expect_snapshot(vascr_units_table())
  
})

test_that("vascr_find_instrument", {
  
  expect_snapshot(vascr_find_instrument(growth.df, "Rb"))
  expect_snapshot(vascr_find_instrument(growth.df, NULL))
  expect_snapshot(vascr_find_instrument(growth.df, "cellZscope"))
  expect_snapshot(vascr_find_instrument(growth.df, c("cellZscope", "ECIS" )))
  expect_snapshot(vascr_find_instrument(growth.df, c("cellZscope", "xCELLigence")))


})


test_that("vascr_find_unit", {
  
  expect_snapshot(vascr_find_unit(growth.df, "raw"))
  expect_snapshot(vascr_find_unit(growth.df, "modeled"))
  expect_snapshot(vascr_find_unit(growth.df, "all"))
  expect_snapshot(vascr_find_unit(growth.df, "Cm"))
  
  expect_snapshot(vascr_find_unit(growth.df, NULL))
  expect_snapshot(vascr_find_unit(growth.df, unit = c("Ci", "Rb")))
  
  expect_snapshot(vascr_find_unit(growth.df, NA))
  expect_snapshot(vascr_find_unit(growth.df %>% mutate(Instrument = "cellZscope"), NA))
  expect_snapshot(vascr_find_unit(growth.df %>% mutate(Instrument = "xCELLigence"), NA))


})

test_that("vascr_find_experiment",{

  expect_snapshot(vascr_find_experiment(growth.df, 1))
   expect_snapshot(vascr_find_experiment(growth.df, "1 : Experiment 1"))
   expect_snapshot(vascr_find_experiment(growth.df, NULL))

})


test_that("vascr_titles render",{
  
  skip_on_ci()
  
  test_render = function(unit, frequency = 1000)
  {
    
    testdata = tribble(~x, ~y,
                       1,1,
                       2,2,
                       3,3)
    
    testgraph = ggplot()+
      geom_line(aes(x = x, y = y), data = testdata) +
      theme(axis.title.x = element_markdown(size = 30)) +
      labs(x = "TEST")
    
    graph = testgraph + labs(x = vascr_titles(unit, frequency))
    print(graph)
    expect_snapshot(vascr_titles(unit, frequency))
    vdiffr::expect_doppelganger(unit,graph)
    
  }
  
  
  test_render("C")
  test_render("R")
  test_render("P")
  test_render("X")
  test_render("Z")
  
  test_render("Rb")
  test_render("Cm")
  test_render("Alpha")
  test_render("RMSE")
  test_render("Drift")
  
  test_render("CI")
  
  
  test_render("CPE_A")
  test_render("CPE_n")
  test_render("TER")
  test_render("Ccl")
  test_render("Rmed")
  
})


test_that("vascr_titles",{
  
  
  expect_snapshot(vascr_titles("random text, not changed"))
  
  
  expect_snapshot(vascr_titles_vector(c("Rb", "R", "Cm")))

  
  
  expect_snapshot(vascr_instrument_units("ECIS"))
  expect_snapshot(vascr_instrument_units("xCELLigence"))
  expect_snapshot(vascr_instrument_units("cellZscope"))
  
  expect_snapshot(vascr_instrument_from_unit("Rb"))
  expect_snapshot(vascr_instrument_from_unit("CI"))
  expect_snapshot(vascr_instrument_from_unit("TER"))
  
})


test_that("test if data is summarised",
{
  
expect_snapshot(vascr_find_level(growth.df))
expect_snapshot(vascr_find_level(vascr_summarise(growth.df, level = "experiments")))
expect_snapshot(vascr_find_level(vascr_summarise(growth.df, level = "summary")))
})

test_that("test vascr file validation", {
  
  test_file_path = system.file('extdata/instruments/ecis_TimeResample.abp', package = 'vascr')
  
  # Check a file with the right extension passes
  expect_snapshot(vascr_validate_file(test_file_path, "abp"))
  # Check a file with one of two right extensions passes
  expect_snapshot(vascr_validate_file(test_file_path, extension = c("abp", "r")))

# check a file that does not exist fails
  expect_error(vascr_validate_file("non_existant_file.R", "P"))
# Check a file with the wrong extension fails
  expect_error(vascr_validate_file(test_file_path, "P"))
# Check a file with the wrong extensions fail
  expect_error(vascr_validate_file(test_file_path, c("P", "q")))



})

test_that("test well standardisation" , {
  
  expect_snapshot(vascr_standardise_wells('A01'))
  expect_snapshot(vascr_standardise_wells('A 1'))

  expect_snapshot(vascr_standardise_wells('tortoise')) # Non-standardize becomes NA
  expect_snapshot(vascr_standardise_wells(growth.df$Well) %>% head())

})

test_that("96 well names are correct", {
  expect_snapshot(vascr_96_well_names())
})

test_that("vascr_gg_hue",{
  expect_snapshot(vascr_gg_color_hue(5))
})

test_that("vascr_colnames_works", {
  expect_snapshot(vascr_cols())
  expect_snapshot(vascr_cols(growth.df, set = "exploded"))
  expect_snapshot(vascr_cols(growth.df, set = "core"))
  expect_snapshot(vascr_cols(growth.df, set = "not_a_set"))
})


test_that("Printing vascr names works", {
  expect_snapshot(vascr_samples(growth.df))
})


test_that("Find metadata works", {

  expect_snapshot(vascr_find_metadata(growth.df))

})


test_that("find col works", {

  expect_snapshot(vascr_find_col(growth.df, "HCMEC/D3"))
  expect_snapshot(vascr_find_col(growth.df, "line"))

})


# test_that("", {
#   
#   expect_snapshot()
#   
# })





