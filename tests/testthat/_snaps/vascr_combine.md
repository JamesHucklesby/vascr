# Can combine dataframes

    Code
      data2
    Output
      # A tibble: 97,170 x 9
          Time Unit  Value Well  Sample       Frequency Experiment Instrument SampleID
         <dbl> <chr> <dbl> <chr> <chr>            <dbl> <fct>      <chr>         <int>
       1     0 Alpha    NA A01   35,000_cell~         0 1 : 1 : E~ ECIS              1
       2     0 Alpha    NA A02   35,000_cell~         0 1 : 1 : E~ ECIS              1
       3     0 Alpha    NA A03   35,000_cell~         0 1 : 1 : E~ ECIS              1
       4     0 Alpha    NA B01   30,000_cell~         0 1 : 1 : E~ ECIS              2
       5     0 Alpha    NA B02   30,000_cell~         0 1 : 1 : E~ ECIS              2
       6     0 Alpha    NA B03   30,000_cell~         0 1 : 1 : E~ ECIS              2
       7     0 Alpha    NA C01   25,000_cell~         0 1 : 1 : E~ ECIS              3
       8     0 Alpha    NA C02   25,000_cell~         0 1 : 1 : E~ ECIS              3
       9     0 Alpha    NA C03   25,000_cell~         0 1 : 1 : E~ ECIS              3
      10     0 Alpha    NA D01   20,000_cell~         0 1 : 1 : E~ ECIS              4
      # i 97,160 more rows

---

    Code
      data3
    Output
      # A tibble: 146,370 x 9
          Time Unit  Value Well  Sample       Frequency Experiment Instrument SampleID
         <dbl> <chr> <dbl> <chr> <chr>            <dbl> <fct>      <chr>         <int>
       1     0 Alpha    NA A01   35,000_cell~         0 1 : 1 : E~ ECIS              1
       2     0 Alpha    NA A02   35,000_cell~         0 1 : 1 : E~ ECIS              1
       3     0 Alpha    NA A03   35,000_cell~         0 1 : 1 : E~ ECIS              1
       4     0 Alpha    NA B01   30,000_cell~         0 1 : 1 : E~ ECIS              2
       5     0 Alpha    NA B02   30,000_cell~         0 1 : 1 : E~ ECIS              2
       6     0 Alpha    NA B03   30,000_cell~         0 1 : 1 : E~ ECIS              2
       7     0 Alpha    NA C01   25,000_cell~         0 1 : 1 : E~ ECIS              3
       8     0 Alpha    NA C02   25,000_cell~         0 1 : 1 : E~ ECIS              3
       9     0 Alpha    NA C03   25,000_cell~         0 1 : 1 : E~ ECIS              3
      10     0 Alpha    NA D01   20,000_cell~         0 1 : 1 : E~ ECIS              4
      # i 146,360 more rows

---

    Code
      vascr_combine(experiment1r.df, experiment2r.df, experiment3.df)
    Condition
      Warning in `vascr_combine()`:
      Datasets have different non-identical timebases. Please resample one or more of these datasets before running this function again or graphs may not be properly generated.
      Warning in `vascr_combine()`:
      Datasets have different non-identical timebases. Please resample one or more of these datasets before running this function again or graphs may not be properly generated.
    Output
      # A tibble: 66,975 x 9
          Time Unit  Value Well  Sample       Frequency Experiment Instrument SampleID
         <dbl> <chr> <dbl> <chr> <chr>            <dbl> <fct>      <chr>         <int>
       1   0   Alpha  2.69 A01   35,000_cell~         0 1 : 1 : E~ ECIS              1
       2  22.2 Alpha  5.05 A01   35,000_cell~         0 1 : 1 : E~ ECIS              1
       3  44.4 Alpha  4.95 A01   35,000_cell~         0 1 : 1 : E~ ECIS              1
       4  66.7 Alpha  3.97 A01   35,000_cell~         0 1 : 1 : E~ ECIS              1
       5  88.9 Alpha  3.72 A01   35,000_cell~         0 1 : 1 : E~ ECIS              1
       6 111.  Alpha  3.48 A01   35,000_cell~         0 1 : 1 : E~ ECIS              1
       7 133.  Alpha  3.27 A01   35,000_cell~         0 1 : 1 : E~ ECIS              1
       8 156.  Alpha  3.12 A01   35,000_cell~         0 1 : 1 : E~ ECIS              1
       9 178.  Alpha  2.89 A01   35,000_cell~         0 1 : 1 : E~ ECIS              1
      10 200   Alpha  2.71 A01   35,000_cell~         0 1 : 1 : E~ ECIS              1
      # i 66,965 more rows

---

    Code
      vascr_combine(experiment1r.df, experiment2r.df, experiment3.df) %>%
        vascr_check_resampled()
    Condition
      Warning in `vascr_combine()`:
      Datasets have different non-identical timebases. Please resample one or more of these datasets before running this function again or graphs may not be properly generated.
      Warning in `vascr_combine()`:
      Datasets have different non-identical timebases. Please resample one or more of these datasets before running this function again or graphs may not be properly generated.
    Output
      [1] FALSE

---

    Code
      vascr_combine(experiment1r.df, experiment2r.df, experiment3.df, resample = TRUE)
    Output
      # A tibble: 17,850 x 9
         Unit  Well  Sample       Frequency Experiment Instrument SampleID Value  Time
         <chr> <chr> <chr>            <dbl> <fct>      <chr>         <int> <dbl> <dbl>
       1 Alpha A01   35,000_cell~         0 1 : 1 : E~ ECIS              1  2.69     0
       2 Alpha A01   35,000_cell~         0 1 : 1 : E~ ECIS              1  4.70    50
       3 Alpha A01   35,000_cell~         0 1 : 1 : E~ ECIS              1  3.60   100
       4 Alpha A01   35,000_cell~         0 1 : 1 : E~ ECIS              1  3.16   150
       5 Alpha A01   35,000_cell~         0 1 : 1 : E~ ECIS              1  2.71   200
       6 Alpha A02   35,000_cell~         0 1 : 1 : E~ ECIS              1  2.89     0
       7 Alpha A02   35,000_cell~         0 1 : 1 : E~ ECIS              1  4.50    50
       8 Alpha A02   35,000_cell~         0 1 : 1 : E~ ECIS              1  3.64   100
       9 Alpha A02   35,000_cell~         0 1 : 1 : E~ ECIS              1  3.16   150
      10 Alpha A02   35,000_cell~         0 1 : 1 : E~ ECIS              1  2.9    200
      # i 17,840 more rows

