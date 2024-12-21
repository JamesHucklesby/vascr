# Can subset correctly

    Code
      vascr_subset(growth.df)
    Output
      # A tibble: 146,370 x 11
          Time Unit  Well  Value Sample    Frequency Experiment cells line  Instrument
         <dbl> <chr> <chr> <dbl> <chr>         <dbl> <fct>      <chr> <chr> <chr>     
       1     0 Alpha A01      NA 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       2     0 Alpha A02      NA 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       3     0 Alpha A03      NA 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       4     0 Alpha B01      NA 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       5     0 Alpha B02      NA 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       6     0 Alpha B03      NA 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       7     0 Alpha C01      NA 25,000_c~         0 1 : Exper~ 25000 HCME~ ECIS      
       8     0 Alpha C02      NA 25,000_c~         0 1 : Exper~ 25000 HCME~ ECIS      
       9     0 Alpha C03      NA 25,000_c~         0 1 : Exper~ 25000 HCME~ ECIS      
      10     0 Alpha D01      NA 20,000_c~         0 1 : Exper~ 20000 HCME~ ECIS      
      # i 146,360 more rows
      # i 1 more variable: SampleID <int>

---

    Code
      vascr_subset(growth.df, time = 40)
    Output
      # A tibble: 3,570 x 11
          Time Unit  Well  Value Sample    Frequency Experiment cells line  Instrument
         <dbl> <chr> <chr> <dbl> <chr>         <dbl> <fct>      <chr> <chr> <chr>     
       1    40 Alpha A01    5.17 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       2    40 Alpha A02    4.89 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       3    40 Alpha A03    5.12 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       4    40 Alpha B01    5.22 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       5    40 Alpha B02    5.36 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       6    40 Alpha B03    5.6  30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       7    40 Alpha C01    5.19 25,000_c~         0 1 : Exper~ 25000 HCME~ ECIS      
       8    40 Alpha C02    5.32 25,000_c~         0 1 : Exper~ 25000 HCME~ ECIS      
       9    40 Alpha C03    4.95 25,000_c~         0 1 : Exper~ 25000 HCME~ ECIS      
      10    40 Alpha D01    4.51 20,000_c~         0 1 : Exper~ 20000 HCME~ ECIS      
      # i 3,560 more rows
      # i 1 more variable: SampleID <int>

---

    Code
      vascr_subset(growth.df, time = c(40, 60))
    Output
      # A tibble: 17,850 x 11
          Time Unit  Well  Value Sample    Frequency Experiment cells line  Instrument
         <dbl> <chr> <chr> <dbl> <chr>         <dbl> <fct>      <chr> <chr> <chr>     
       1    40 Alpha A01    5.17 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       2    40 Alpha A02    4.89 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       3    40 Alpha A03    5.12 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       4    40 Alpha B01    5.22 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       5    40 Alpha B02    5.36 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       6    40 Alpha B03    5.6  30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       7    40 Alpha C01    5.19 25,000_c~         0 1 : Exper~ 25000 HCME~ ECIS      
       8    40 Alpha C02    5.32 25,000_c~         0 1 : Exper~ 25000 HCME~ ECIS      
       9    40 Alpha C03    4.95 25,000_c~         0 1 : Exper~ 25000 HCME~ ECIS      
      10    40 Alpha D01    4.51 20,000_c~         0 1 : Exper~ 20000 HCME~ ECIS      
      # i 17,840 more rows
      # i 1 more variable: SampleID <int>

---

    Code
      vascr_subset(growth.df, time = NULL)
    Output
      # A tibble: 146,370 x 11
          Time Unit  Well  Value Sample    Frequency Experiment cells line  Instrument
         <dbl> <chr> <chr> <dbl> <chr>         <dbl> <fct>      <chr> <chr> <chr>     
       1     0 Alpha A01      NA 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       2     0 Alpha A02      NA 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       3     0 Alpha A03      NA 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       4     0 Alpha B01      NA 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       5     0 Alpha B02      NA 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       6     0 Alpha B03      NA 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       7     0 Alpha C01      NA 25,000_c~         0 1 : Exper~ 25000 HCME~ ECIS      
       8     0 Alpha C02      NA 25,000_c~         0 1 : Exper~ 25000 HCME~ ECIS      
       9     0 Alpha C03      NA 25,000_c~         0 1 : Exper~ 25000 HCME~ ECIS      
      10     0 Alpha D01      NA 20,000_c~         0 1 : Exper~ 20000 HCME~ ECIS      
      # i 146,360 more rows
      # i 1 more variable: SampleID <int>

---

    Code
      vascr_subset(growth.df, unit = "Rb")
    Output
      # A tibble: 2,706 x 11
          Time Unit  Well  Value Sample    Frequency Experiment cells line  Instrument
         <dbl> <fct> <chr> <dbl> <chr>         <dbl> <fct>      <chr> <chr> <chr>     
       1     0 Rb    A01      NA 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       2     0 Rb    A02      NA 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       3     0 Rb    A03      NA 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       4     0 Rb    B01      NA 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       5     0 Rb    B02      NA 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       6     0 Rb    B03      NA 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       7     0 Rb    C01      NA 25,000_c~         0 1 : Exper~ 25000 HCME~ ECIS      
       8     0 Rb    C02      NA 25,000_c~         0 1 : Exper~ 25000 HCME~ ECIS      
       9     0 Rb    C03      NA 25,000_c~         0 1 : Exper~ 25000 HCME~ ECIS      
      10     0 Rb    D01      NA 20,000_c~         0 1 : Exper~ 20000 HCME~ ECIS      
      # i 2,696 more rows
      # i 1 more variable: SampleID <int>

---

    Code
      vascr_subset(growth.df, unit = "R")
    Output
      # A tibble: 26,568 x 11
          Time Unit  Well  Value Sample    Frequency Experiment cells line  Instrument
         <dbl> <fct> <chr> <dbl> <chr>         <dbl> <fct>      <chr> <chr> <chr>     
       1     0 R     A01     NA  35,000_c~      1000 1 : Exper~ 35000 HCME~ ECIS      
       2     5 R     A01    413. 35,000_c~      1000 1 : Exper~ 35000 HCME~ ECIS      
       3    10 R     A01    470. 35,000_c~      1000 1 : Exper~ 35000 HCME~ ECIS      
       4    15 R     A01    556. 35,000_c~      1000 1 : Exper~ 35000 HCME~ ECIS      
       5    20 R     A01    630. 35,000_c~      1000 1 : Exper~ 35000 HCME~ ECIS      
       6    25 R     A01    677. 35,000_c~      1000 1 : Exper~ 35000 HCME~ ECIS      
       7    30 R     A01    695. 35,000_c~      1000 1 : Exper~ 35000 HCME~ ECIS      
       8    35 R     A01    729. 35,000_c~      1000 1 : Exper~ 35000 HCME~ ECIS      
       9    40 R     A01    768. 35,000_c~      1000 1 : Exper~ 35000 HCME~ ECIS      
      10    45 R     A01    801. 35,000_c~      1000 1 : Exper~ 35000 HCME~ ECIS      
      # i 26,558 more rows
      # i 1 more variable: SampleID <int>

---

    Code
      vascr_subset(growth.df, well = "A1")
    Output
      # A tibble: 2,050 x 11
          Time Unit  Well  Value Sample    Frequency Experiment cells line  Instrument
         <dbl> <chr> <chr> <dbl> <chr>         <dbl> <fct>      <chr> <chr> <chr>     
       1     0 Alpha A01   NA    35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       2     0 Cm    A01   NA    35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       3     0 Drift A01   NA    35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       4     0 Rb    A01   NA    35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       5     0 RMSE  A01   NA    35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       6     5 Alpha A01    2.69 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       7     5 Cm    A01   37.9  35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       8     5 Drift A01   -0.94 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       9     5 Rb    A01    0    35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
      10     5 RMSE  A01    0.01 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
      # i 2,040 more rows
      # i 1 more variable: SampleID <int>

---

    Code
      vascr_subset(growth.df, well = "B12")
    Condition
      Warning in `vascr_match()`:
      [B12] corrected to [B02]. Please check the argeuments for your functions are correctly typed.
    Output
      # A tibble: 2,050 x 11
          Time Unit  Well  Value Sample    Frequency Experiment cells line  Instrument
         <dbl> <chr> <chr> <dbl> <chr>         <dbl> <fct>      <chr> <chr> <chr>     
       1     0 Alpha B02   NA    30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       2     0 Cm    B02   NA    30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       3     0 Drift B02   NA    30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       4     0 Rb    B02   NA    30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       5     0 RMSE  B02   NA    30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       6     5 Alpha B02    2.69 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       7     5 Cm    B02   37.7  30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       8     5 Drift B02   -1.1  30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       9     5 Rb    B02    0    30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
      10     5 RMSE  B02    0.01 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
      # i 2,040 more rows
      # i 1 more variable: SampleID <int>

---

    Code
      vascr_subset(growth.df, well = "B20")
    Condition
      Warning in `vascr_standardise_wells()`:
      Well NA is not a valid well name, please check your input data
      Warning in `vascr_match()`:
      [NA] corrected to [A01]. Please check the argeuments for your functions are correctly typed.
    Output
      # A tibble: 2,050 x 11
          Time Unit  Well  Value Sample    Frequency Experiment cells line  Instrument
         <dbl> <chr> <chr> <dbl> <chr>         <dbl> <fct>      <chr> <chr> <chr>     
       1     0 Alpha A01   NA    35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       2     0 Cm    A01   NA    35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       3     0 Drift A01   NA    35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       4     0 Rb    A01   NA    35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       5     0 RMSE  A01   NA    35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       6     5 Alpha A01    2.69 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       7     5 Cm    A01   37.9  35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       8     5 Drift A01   -0.94 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       9     5 Rb    A01    0    35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
      10     5 RMSE  A01    0.01 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
      # i 2,040 more rows
      # i 1 more variable: SampleID <int>

---

    Code
      vascr_subset(growth.df, well = c("B2", "B03"))
    Output
      # A tibble: 4,100 x 11
          Time Unit  Well  Value Sample    Frequency Experiment cells line  Instrument
         <dbl> <chr> <chr> <dbl> <chr>         <dbl> <fct>      <chr> <chr> <chr>     
       1     0 Alpha B02      NA 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       2     0 Alpha B03      NA 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       3     0 Cm    B02      NA 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       4     0 Cm    B03      NA 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       5     0 Drift B02      NA 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       6     0 Drift B03      NA 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       7     0 Rb    B02      NA 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       8     0 Rb    B03      NA 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       9     0 RMSE  B02      NA 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
      10     0 RMSE  B03      NA 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
      # i 4,090 more rows
      # i 1 more variable: SampleID <int>

---

    Code
      vascr_subset(growth.df, well = c("-A01", "-B3"))
    Output
      # A tibble: 142,270 x 11
          Time Unit  Well  Value Sample    Frequency Experiment cells line  Instrument
         <dbl> <chr> <chr> <dbl> <chr>         <dbl> <fct>      <chr> <chr> <chr>     
       1     0 Alpha A02      NA 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       2     0 Alpha A03      NA 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       3     0 Alpha B01      NA 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       4     0 Alpha B02      NA 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       5     0 Alpha C01      NA 25,000_c~         0 1 : Exper~ 25000 HCME~ ECIS      
       6     0 Alpha C02      NA 25,000_c~         0 1 : Exper~ 25000 HCME~ ECIS      
       7     0 Alpha C03      NA 25,000_c~         0 1 : Exper~ 25000 HCME~ ECIS      
       8     0 Alpha D01      NA 20,000_c~         0 1 : Exper~ 20000 HCME~ ECIS      
       9     0 Alpha D02      NA 20,000_c~         0 1 : Exper~ 20000 HCME~ ECIS      
      10     0 Alpha D03      NA 20,000_c~         0 1 : Exper~ 20000 HCME~ ECIS      
      # i 142,260 more rows
      # i 1 more variable: SampleID <int>

---

    Code
      vascr_subset(growth.df, frequency = 4000)
    Output
      # A tibble: 14,760 x 11
          Time Unit  Well  Value Sample    Frequency Experiment cells line  Instrument
         <dbl> <chr> <chr> <dbl> <chr>         <dbl> <fct>      <chr> <chr> <chr>     
       1     0 C     A01    NA   35,000_c~      4000 1 : Exper~ 35000 HCME~ ECIS      
       2     5 C     A01   104.  35,000_c~      4000 1 : Exper~ 35000 HCME~ ECIS      
       3    10 C     A01    98.8 35,000_c~      4000 1 : Exper~ 35000 HCME~ ECIS      
       4    15 C     A01    92.3 35,000_c~      4000 1 : Exper~ 35000 HCME~ ECIS      
       5    20 C     A01    88.4 35,000_c~      4000 1 : Exper~ 35000 HCME~ ECIS      
       6    25 C     A01    86.9 35,000_c~      4000 1 : Exper~ 35000 HCME~ ECIS      
       7    30 C     A01    86.8 35,000_c~      4000 1 : Exper~ 35000 HCME~ ECIS      
       8    35 C     A01    86.7 35,000_c~      4000 1 : Exper~ 35000 HCME~ ECIS      
       9    40 C     A01    87.9 35,000_c~      4000 1 : Exper~ 35000 HCME~ ECIS      
      10    45 C     A01    90.0 35,000_c~      4000 1 : Exper~ 35000 HCME~ ECIS      
      # i 14,750 more rows
      # i 1 more variable: SampleID <int>

---

    Code
      vascr_subset(growth.df %>% mutate(Frequency = as.character(Frequency)),
      frequency = "4000")
    Output
      # A tibble: 14,760 x 11
          Time Unit  Well  Value Sample    Frequency Experiment cells line  Instrument
         <dbl> <chr> <chr> <dbl> <chr>         <dbl> <fct>      <chr> <chr> <chr>     
       1     0 C     A01    NA   35,000_c~      4000 1 : Exper~ 35000 HCME~ ECIS      
       2     5 C     A01   104.  35,000_c~      4000 1 : Exper~ 35000 HCME~ ECIS      
       3    10 C     A01    98.8 35,000_c~      4000 1 : Exper~ 35000 HCME~ ECIS      
       4    15 C     A01    92.3 35,000_c~      4000 1 : Exper~ 35000 HCME~ ECIS      
       5    20 C     A01    88.4 35,000_c~      4000 1 : Exper~ 35000 HCME~ ECIS      
       6    25 C     A01    86.9 35,000_c~      4000 1 : Exper~ 35000 HCME~ ECIS      
       7    30 C     A01    86.8 35,000_c~      4000 1 : Exper~ 35000 HCME~ ECIS      
       8    35 C     A01    86.7 35,000_c~      4000 1 : Exper~ 35000 HCME~ ECIS      
       9    40 C     A01    87.9 35,000_c~      4000 1 : Exper~ 35000 HCME~ ECIS      
      10    45 C     A01    90.0 35,000_c~      4000 1 : Exper~ 35000 HCME~ ECIS      
      # i 14,750 more rows
      # i 1 more variable: SampleID <int>

---

    Code
      vascr_subset(growth.df, experiment = 1)
    Output
      # A tibble: 48,585 x 11
          Time Unit  Well  Value Sample    Frequency Experiment cells line  Instrument
         <dbl> <chr> <chr> <dbl> <chr>         <dbl> <fct>      <chr> <chr> <chr>     
       1     0 Alpha A01      NA 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       2     0 Alpha A02      NA 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       3     0 Alpha A03      NA 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       4     0 Alpha B01      NA 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       5     0 Alpha B02      NA 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       6     0 Alpha B03      NA 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       7     0 Alpha C01      NA 25,000_c~         0 1 : Exper~ 25000 HCME~ ECIS      
       8     0 Alpha C02      NA 25,000_c~         0 1 : Exper~ 25000 HCME~ ECIS      
       9     0 Alpha C03      NA 25,000_c~         0 1 : Exper~ 25000 HCME~ ECIS      
      10     0 Alpha D01      NA 20,000_c~         0 1 : Exper~ 20000 HCME~ ECIS      
      # i 48,575 more rows
      # i 1 more variable: SampleID <int>

---

    Code
      vascr_subset(growth.df, experiment = 1)
    Output
      # A tibble: 48,585 x 11
          Time Unit  Well  Value Sample    Frequency Experiment cells line  Instrument
         <dbl> <chr> <chr> <dbl> <chr>         <dbl> <fct>      <chr> <chr> <chr>     
       1     0 Alpha A01      NA 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       2     0 Alpha A02      NA 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       3     0 Alpha A03      NA 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       4     0 Alpha B01      NA 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       5     0 Alpha B02      NA 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       6     0 Alpha B03      NA 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       7     0 Alpha C01      NA 25,000_c~         0 1 : Exper~ 25000 HCME~ ECIS      
       8     0 Alpha C02      NA 25,000_c~         0 1 : Exper~ 25000 HCME~ ECIS      
       9     0 Alpha C03      NA 25,000_c~         0 1 : Exper~ 25000 HCME~ ECIS      
      10     0 Alpha D01      NA 20,000_c~         0 1 : Exper~ 20000 HCME~ ECIS      
      # i 48,575 more rows
      # i 1 more variable: SampleID <int>

---

    Code
      vascr_subset(growth.df, instrument = "ECIS")
    Output
      # A tibble: 146,370 x 11
          Time Unit  Well  Value Sample    Frequency Experiment cells line  Instrument
         <dbl> <chr> <chr> <dbl> <chr>         <dbl> <fct>      <chr> <chr> <chr>     
       1     0 Alpha A01      NA 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       2     0 Alpha A02      NA 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       3     0 Alpha A03      NA 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       4     0 Alpha B01      NA 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       5     0 Alpha B02      NA 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       6     0 Alpha B03      NA 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       7     0 Alpha C01      NA 25,000_c~         0 1 : Exper~ 25000 HCME~ ECIS      
       8     0 Alpha C02      NA 25,000_c~         0 1 : Exper~ 25000 HCME~ ECIS      
       9     0 Alpha C03      NA 25,000_c~         0 1 : Exper~ 25000 HCME~ ECIS      
      10     0 Alpha D01      NA 20,000_c~         0 1 : Exper~ 20000 HCME~ ECIS      
      # i 146,360 more rows
      # i 1 more variable: SampleID <int>

---

    Code
      vascr_subset(growth.df, unit = "Rb", sampleid = c(1:3))
    Output
      # A tibble: 1,107 x 11
          Time Unit  Well  Value Sample    Frequency Experiment cells line  Instrument
         <dbl> <fct> <chr> <dbl> <fct>         <dbl> <fct>      <chr> <chr> <chr>     
       1     0 Rb    A01      NA 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       2     0 Rb    A02      NA 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       3     0 Rb    A03      NA 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       4     0 Rb    B01      NA 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       5     0 Rb    B02      NA 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       6     0 Rb    B03      NA 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       7     0 Rb    C01      NA 25,000_c~         0 1 : Exper~ 25000 HCME~ ECIS      
       8     0 Rb    C02      NA 25,000_c~         0 1 : Exper~ 25000 HCME~ ECIS      
       9     0 Rb    C03      NA 25,000_c~         0 1 : Exper~ 25000 HCME~ ECIS      
      10     5 Rb    A01       0 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
      # i 1,097 more rows
      # i 1 more variable: SampleID <int>

---

    Code
      vascr_subset(growth.df, unit = "Rb", sampleid = c(8))
    Output
      # A tibble: 123 x 11
          Time Unit  Well  Value Sample    Frequency Experiment cells line  Instrument
         <dbl> <fct> <chr> <dbl> <fct>         <dbl> <fct>      <chr> <chr> <chr>     
       1     0 Rb    H07      NA 0_cells ~         0 3 : Exper~ 0     HCME~ ECIS      
       2     0 Rb    H08      NA 0_cells ~         0 3 : Exper~ 0     HCME~ ECIS      
       3     0 Rb    H09      NA 0_cells ~         0 3 : Exper~ 0     HCME~ ECIS      
       4     5 Rb    H07       0 0_cells ~         0 3 : Exper~ 0     HCME~ ECIS      
       5     5 Rb    H08       0 0_cells ~         0 3 : Exper~ 0     HCME~ ECIS      
       6     5 Rb    H09       0 0_cells ~         0 3 : Exper~ 0     HCME~ ECIS      
       7    10 Rb    H07       0 0_cells ~         0 3 : Exper~ 0     HCME~ ECIS      
       8    10 Rb    H08       0 0_cells ~         0 3 : Exper~ 0     HCME~ ECIS      
       9    10 Rb    H09       0 0_cells ~         0 3 : Exper~ 0     HCME~ ECIS      
      10    15 Rb    H07       0 0_cells ~         0 3 : Exper~ 0     HCME~ ECIS      
      # i 113 more rows
      # i 1 more variable: SampleID <int>

---

    Code
      vascr_subset(growth.df, subsample = 100)
    Output
      # A tibble: 3,570 x 11
          Time Unit  Well  Value Sample    Frequency Experiment cells line  Instrument
         <dbl> <chr> <chr> <dbl> <chr>         <dbl> <fct>      <chr> <chr> <chr>     
       1     0 Alpha A01      NA 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       2     0 Alpha A02      NA 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       3     0 Alpha A03      NA 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       4     0 Alpha B01      NA 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       5     0 Alpha B02      NA 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       6     0 Alpha B03      NA 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       7     0 Alpha C01      NA 25,000_c~         0 1 : Exper~ 25000 HCME~ ECIS      
       8     0 Alpha C02      NA 25,000_c~         0 1 : Exper~ 25000 HCME~ ECIS      
       9     0 Alpha C03      NA 25,000_c~         0 1 : Exper~ 25000 HCME~ ECIS      
      10     0 Alpha D01      NA 20,000_c~         0 1 : Exper~ 20000 HCME~ ECIS      
      # i 3,560 more rows
      # i 1 more variable: SampleID <int>

---

    Code
      vascr_subset(growth.df, unit = "Rb", sampleid = 10)
    Condition
      Warning in `vascr_subset()`:
      No data returned from dataset subset. Check your frequencies, times and units are present in the dataset
    Output
      # A tibble: 0 x 11
      # i 11 variables: Time <dbl>, Unit <fct>, Well <chr>, Value <dbl>,
      #   Sample <fct>, Frequency <dbl>, Experiment <fct>, cells <chr>, line <chr>,
      #   Instrument <chr>, SampleID <int>

