# Can combine dataframes

    Code
      data2
    Output
      # A tibble: 92,430 x 9
          Time Unit  Value Well  Sample       Frequency Experiment Instrument SampleID
         <dbl> <chr> <dbl> <chr> <chr>            <dbl> <fct>      <chr>         <int>
       1     5 Alpha  2.69 A01   35,000_cell~         0 1 : 1 : E~ ECIS              1
       2     5 Alpha  2.89 A02   35,000_cell~         0 1 : 1 : E~ ECIS              1
       3     5 Alpha  2.71 A03   35,000_cell~         0 1 : 1 : E~ ECIS              1
       4     5 Alpha  2.52 B01   30,000_cell~         0 1 : 1 : E~ ECIS              2
       5     5 Alpha  2.69 B02   30,000_cell~         0 1 : 1 : E~ ECIS              2
       6     5 Alpha  2.34 B03   30,000_cell~         0 1 : 1 : E~ ECIS              2
       7     5 Alpha  2.15 C01   25,000_cell~         0 1 : 1 : E~ ECIS              3
       8     5 Alpha  2.35 C02   25,000_cell~         0 1 : 1 : E~ ECIS              3
       9     5 Alpha  2.4  C03   25,000_cell~         0 1 : 1 : E~ ECIS              3
      10     5 Alpha  1.85 D01   20,000_cell~         0 1 : 1 : E~ ECIS              4
      # i 92,420 more rows

---

    Code
      data3
    Output
      # A tibble: 139,230 x 9
          Time Unit  Value Well  Sample       Frequency Experiment Instrument SampleID
         <dbl> <chr> <dbl> <chr> <chr>            <dbl> <fct>      <chr>         <int>
       1     5 Alpha  2.69 A01   35,000_cell~         0 1 : 1 : E~ ECIS              1
       2     5 Alpha  2.89 A02   35,000_cell~         0 1 : 1 : E~ ECIS              1
       3     5 Alpha  2.71 A03   35,000_cell~         0 1 : 1 : E~ ECIS              1
       4     5 Alpha  2.52 B01   30,000_cell~         0 1 : 1 : E~ ECIS              2
       5     5 Alpha  2.69 B02   30,000_cell~         0 1 : 1 : E~ ECIS              2
       6     5 Alpha  2.34 B03   30,000_cell~         0 1 : 1 : E~ ECIS              2
       7     5 Alpha  2.15 C01   25,000_cell~         0 1 : 1 : E~ ECIS              3
       8     5 Alpha  2.35 C02   25,000_cell~         0 1 : 1 : E~ ECIS              3
       9     5 Alpha  2.4  C03   25,000_cell~         0 1 : 1 : E~ ECIS              3
      10     5 Alpha  1.85 D01   20,000_cell~         0 1 : 1 : E~ ECIS              4
      # i 139,220 more rows

---

    Code
      vascr_combine(experiment1r.df, experiment2r.df, experiment3.df)
    Message
      ! Datasets have different non-identical timebases. Please resample one or more of these datasets before running this function again or graphs may not be properly generated.
      ! Datasets have different non-identical timebases. Please resample one or more of these datasets before running this function again or graphs may not be properly generated.
    Output
      # A tibble: 64,575 x 9
          Time Unit  Value Well  Sample       Frequency Experiment Instrument SampleID
         <dbl> <chr> <dbl> <chr> <chr>            <dbl> <fct>      <chr>         <int>
       1   5   Alpha  2.69 A01   35,000_cell~         0 1 : 1 : E~ ECIS              1
       2  26.1 Alpha  5.31 A01   35,000_cell~         0 1 : 1 : E~ ECIS              1
       3  47.2 Alpha  4.8  A01   35,000_cell~         0 1 : 1 : E~ ECIS              1
       4  68.3 Alpha  3.94 A01   35,000_cell~         0 1 : 1 : E~ ECIS              1
       5  89.4 Alpha  3.71 A01   35,000_cell~         0 1 : 1 : E~ ECIS              1
       6 111.  Alpha  3.49 A01   35,000_cell~         0 1 : 1 : E~ ECIS              1
       7 132.  Alpha  3.29 A01   35,000_cell~         0 1 : 1 : E~ ECIS              1
       8 153.  Alpha  3.13 A01   35,000_cell~         0 1 : 1 : E~ ECIS              1
       9 174.  Alpha  2.93 A01   35,000_cell~         0 1 : 1 : E~ ECIS              1
      10 195   Alpha  2.71 A01   35,000_cell~         0 1 : 1 : E~ ECIS              1
      # i 64,565 more rows

---

    Code
      vascr_combine(experiment1r.df, experiment2r.df, experiment3.df) %>%
        vascr_check_resampled()
    Message
      ! Datasets have different non-identical timebases. Please resample one or more of these datasets before running this function again or graphs may not be properly generated.
      ! Datasets have different non-identical timebases. Please resample one or more of these datasets before running this function again or graphs may not be properly generated.
    Output
      [1] FALSE

---

    Code
      vascr_combine(experiment1r.df, experiment2r.df, experiment3.df, resample = TRUE)
    Output
      # A tibble: 17,850 x 9
         Unit  Well  Sample       Frequency Experiment Instrument SampleID Value  Time
         <chr> <chr> <chr>            <dbl> <fct>      <chr>         <int> <dbl> <dbl>
       1 Alpha A01   35,000_cell~         0 1 : 1 : E~ ECIS              1  2.69   5  
       2 Alpha A01   35,000_cell~         0 1 : 1 : E~ ECIS              1  4.58  52.5
       3 Alpha A01   35,000_cell~         0 1 : 1 : E~ ECIS              1  3.60 100  
       4 Alpha A01   35,000_cell~         0 1 : 1 : E~ ECIS              1  3.17 148. 
       5 Alpha A01   35,000_cell~         0 1 : 1 : E~ ECIS              1  2.71 195  
       6 Alpha A02   35,000_cell~         0 1 : 1 : E~ ECIS              1  2.89   5  
       7 Alpha A02   35,000_cell~         0 1 : 1 : E~ ECIS              1  4.40  52.5
       8 Alpha A02   35,000_cell~         0 1 : 1 : E~ ECIS              1  3.64 100  
       9 Alpha A02   35,000_cell~         0 1 : 1 : E~ ECIS              1  3.18 148. 
      10 Alpha A02   35,000_cell~         0 1 : 1 : E~ ECIS              1  2.9  195  
      # i 17,840 more rows

