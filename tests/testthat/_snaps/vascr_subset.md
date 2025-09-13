# Can subset correctly

    Code
      vascr_subset(growth.df)
    Output
      # A tibble: 139,230 x 12
          Time Unit  Well  Value Sample    Frequency Experiment cells line  Instrument
         <dbl> <chr> <chr> <dbl> <chr>         <dbl> <fct>      <chr> <chr> <chr>     
       1     5 Alpha A01    2.69 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       2     5 Alpha A02    2.89 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       3     5 Alpha A03    2.71 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       4     5 Alpha B01    2.52 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       5     5 Alpha B02    2.69 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       6     5 Alpha B03    2.34 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       7     5 Alpha C01    2.15 25,000_c~         0 1 : Exper~ 25000 HCME~ ECIS      
       8     5 Alpha C02    2.35 25,000_c~         0 1 : Exper~ 25000 HCME~ ECIS      
       9     5 Alpha C03    2.4  25,000_c~         0 1 : Exper~ 25000 HCME~ ECIS      
      10     5 Alpha D01    1.85 20,000_c~         0 1 : Exper~ 20000 HCME~ ECIS      
      # i 139,220 more rows
      # i 2 more variables: SampleID <int>, Excluded <chr>

---

    Code
      vascr_subset(growth.df, time = 40)
    Output
      # A tibble: 3,570 x 12
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
      # i 2 more variables: SampleID <int>, Excluded <chr>

---

    Code
      vascr_subset(growth.df, time = c(40, 60))
    Output
      # A tibble: 17,850 x 12
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
      # i 2 more variables: SampleID <int>, Excluded <chr>

---

    Code
      vascr_subset(growth.df, time = NULL)
    Output
      # A tibble: 139,230 x 12
          Time Unit  Well  Value Sample    Frequency Experiment cells line  Instrument
         <dbl> <chr> <chr> <dbl> <chr>         <dbl> <fct>      <chr> <chr> <chr>     
       1     5 Alpha A01    2.69 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       2     5 Alpha A02    2.89 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       3     5 Alpha A03    2.71 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       4     5 Alpha B01    2.52 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       5     5 Alpha B02    2.69 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       6     5 Alpha B03    2.34 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       7     5 Alpha C01    2.15 25,000_c~         0 1 : Exper~ 25000 HCME~ ECIS      
       8     5 Alpha C02    2.35 25,000_c~         0 1 : Exper~ 25000 HCME~ ECIS      
       9     5 Alpha C03    2.4  25,000_c~         0 1 : Exper~ 25000 HCME~ ECIS      
      10     5 Alpha D01    1.85 20,000_c~         0 1 : Exper~ 20000 HCME~ ECIS      
      # i 139,220 more rows
      # i 2 more variables: SampleID <int>, Excluded <chr>

---

    Code
      vascr_subset(growth.df, unit = "Rb")
    Output
      # A tibble: 2,574 x 12
          Time Unit  Well  Value Sample    Frequency Experiment cells line  Instrument
         <dbl> <fct> <chr> <dbl> <chr>         <dbl> <fct>      <chr> <chr> <chr>     
       1     5 Rb    A01       0 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       2     5 Rb    A02       0 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       3     5 Rb    A03       0 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       4     5 Rb    B01       0 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       5     5 Rb    B02       0 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       6     5 Rb    B03       0 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       7     5 Rb    C01       0 25,000_c~         0 1 : Exper~ 25000 HCME~ ECIS      
       8     5 Rb    C02       0 25,000_c~         0 1 : Exper~ 25000 HCME~ ECIS      
       9     5 Rb    C03       0 25,000_c~         0 1 : Exper~ 25000 HCME~ ECIS      
      10     5 Rb    D01       0 20,000_c~         0 1 : Exper~ 20000 HCME~ ECIS      
      # i 2,564 more rows
      # i 2 more variables: SampleID <int>, Excluded <chr>

---

    Code
      vascr_subset(growth.df, unit = "R")
    Output
      # A tibble: 25,272 x 12
          Time Unit  Well  Value Sample    Frequency Experiment cells line  Instrument
         <dbl> <fct> <chr> <dbl> <chr>         <dbl> <fct>      <chr> <chr> <chr>     
       1     5 R     A01    413. 35,000_c~      1000 1 : Exper~ 35000 HCME~ ECIS      
       2    10 R     A01    470. 35,000_c~      1000 1 : Exper~ 35000 HCME~ ECIS      
       3    15 R     A01    556. 35,000_c~      1000 1 : Exper~ 35000 HCME~ ECIS      
       4    20 R     A01    630. 35,000_c~      1000 1 : Exper~ 35000 HCME~ ECIS      
       5    25 R     A01    677. 35,000_c~      1000 1 : Exper~ 35000 HCME~ ECIS      
       6    30 R     A01    695. 35,000_c~      1000 1 : Exper~ 35000 HCME~ ECIS      
       7    35 R     A01    729. 35,000_c~      1000 1 : Exper~ 35000 HCME~ ECIS      
       8    40 R     A01    768. 35,000_c~      1000 1 : Exper~ 35000 HCME~ ECIS      
       9    45 R     A01    801. 35,000_c~      1000 1 : Exper~ 35000 HCME~ ECIS      
      10    50 R     A01    815. 35,000_c~      1000 1 : Exper~ 35000 HCME~ ECIS      
      # i 25,262 more rows
      # i 2 more variables: SampleID <int>, Excluded <chr>

---

    Code
      vascr_subset(growth.df, well = "A1")
    Output
      # A tibble: 1,950 x 12
          Time Unit  Well  Value Sample    Frequency Experiment cells line  Instrument
         <dbl> <chr> <chr> <dbl> <chr>         <dbl> <fct>      <chr> <chr> <chr>     
       1     5 Alpha A01    2.69 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       2     5 Cm    A01   37.9  35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       3     5 Drift A01   -0.94 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       4     5 Rb    A01    0    35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       5     5 RMSE  A01    0.01 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       6    10 Alpha A01    3.34 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       7    10 Cm    A01   18.8  35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       8    10 Drift A01   -1.82 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       9    10 Rb    A01    0    35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
      10    10 RMSE  A01    0.02 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
      # i 1,940 more rows
      # i 2 more variables: SampleID <int>, Excluded <chr>

---

    Code
      vascr_subset(growth.df, well = "B12")
    Message
      ! [B12] corrected to [B02]. Please check the argeuments for your functions are correctly typed.
    Output
      # A tibble: 1,950 x 12
          Time Unit  Well  Value Sample    Frequency Experiment cells line  Instrument
         <dbl> <chr> <chr> <dbl> <chr>         <dbl> <fct>      <chr> <chr> <chr>     
       1     5 Alpha B02    2.69 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       2     5 Cm    B02   37.7  30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       3     5 Drift B02   -1.1  30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       4     5 Rb    B02    0    30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       5     5 RMSE  B02    0.01 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       6    10 Alpha B02    3.4  30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       7    10 Cm    B02   18.1  30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       8    10 Drift B02   -2.16 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       9    10 Rb    B02    0    30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
      10    10 RMSE  B02    0.02 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
      # i 1,940 more rows
      # i 2 more variables: SampleID <int>, Excluded <chr>

---

    Code
      vascr_subset(growth.df, well = "B20")
    Message
      ! Well NA is not a valid well name, please check your input data
      ! [NA] corrected to [A01]. Please check the argeuments for your functions are correctly typed.
    Output
      # A tibble: 1,950 x 12
          Time Unit  Well  Value Sample    Frequency Experiment cells line  Instrument
         <dbl> <chr> <chr> <dbl> <chr>         <dbl> <fct>      <chr> <chr> <chr>     
       1     5 Alpha A01    2.69 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       2     5 Cm    A01   37.9  35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       3     5 Drift A01   -0.94 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       4     5 Rb    A01    0    35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       5     5 RMSE  A01    0.01 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       6    10 Alpha A01    3.34 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       7    10 Cm    A01   18.8  35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       8    10 Drift A01   -1.82 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       9    10 Rb    A01    0    35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
      10    10 RMSE  A01    0.02 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
      # i 1,940 more rows
      # i 2 more variables: SampleID <int>, Excluded <chr>

---

    Code
      vascr_subset(growth.df, well = c("B2", "B03"))
    Output
      # A tibble: 3,900 x 12
          Time Unit  Well  Value Sample    Frequency Experiment cells line  Instrument
         <dbl> <chr> <chr> <dbl> <chr>         <dbl> <fct>      <chr> <chr> <chr>     
       1     5 Alpha B02    2.69 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       2     5 Alpha B03    2.34 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       3     5 Cm    B02   37.7  30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       4     5 Cm    B03   49.0  30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       5     5 Drift B02   -1.1  30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       6     5 Drift B03   -0.58 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       7     5 Rb    B02    0    30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       8     5 Rb    B03    0    30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       9     5 RMSE  B02    0.01 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
      10     5 RMSE  B03    0.01 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
      # i 3,890 more rows
      # i 2 more variables: SampleID <int>, Excluded <chr>

---

    Code
      vascr_subset(growth.df, well = c("-A01", "-B3"))
    Output
      # A tibble: 135,330 x 12
          Time Unit  Well  Value Sample    Frequency Experiment cells line  Instrument
         <dbl> <chr> <chr> <dbl> <chr>         <dbl> <fct>      <chr> <chr> <chr>     
       1     5 Alpha A02    2.89 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       2     5 Alpha A03    2.71 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       3     5 Alpha B01    2.52 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       4     5 Alpha B02    2.69 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       5     5 Alpha C01    2.15 25,000_c~         0 1 : Exper~ 25000 HCME~ ECIS      
       6     5 Alpha C02    2.35 25,000_c~         0 1 : Exper~ 25000 HCME~ ECIS      
       7     5 Alpha C03    2.4  25,000_c~         0 1 : Exper~ 25000 HCME~ ECIS      
       8     5 Alpha D01    1.85 20,000_c~         0 1 : Exper~ 20000 HCME~ ECIS      
       9     5 Alpha D02    2.02 20,000_c~         0 1 : Exper~ 20000 HCME~ ECIS      
      10     5 Alpha D03    2.05 20,000_c~         0 1 : Exper~ 20000 HCME~ ECIS      
      # i 135,320 more rows
      # i 2 more variables: SampleID <int>, Excluded <chr>

---

    Code
      vascr_subset(growth.df, frequency = 4000)
    Output
      # A tibble: 14,040 x 12
          Time Unit  Well  Value Sample    Frequency Experiment cells line  Instrument
         <dbl> <chr> <chr> <dbl> <chr>         <dbl> <fct>      <chr> <chr> <chr>     
       1     5 C     A01   104.  35,000_c~      4000 1 : Exper~ 35000 HCME~ ECIS      
       2    10 C     A01    98.8 35,000_c~      4000 1 : Exper~ 35000 HCME~ ECIS      
       3    15 C     A01    92.3 35,000_c~      4000 1 : Exper~ 35000 HCME~ ECIS      
       4    20 C     A01    88.4 35,000_c~      4000 1 : Exper~ 35000 HCME~ ECIS      
       5    25 C     A01    86.9 35,000_c~      4000 1 : Exper~ 35000 HCME~ ECIS      
       6    30 C     A01    86.8 35,000_c~      4000 1 : Exper~ 35000 HCME~ ECIS      
       7    35 C     A01    86.7 35,000_c~      4000 1 : Exper~ 35000 HCME~ ECIS      
       8    40 C     A01    87.9 35,000_c~      4000 1 : Exper~ 35000 HCME~ ECIS      
       9    45 C     A01    90.0 35,000_c~      4000 1 : Exper~ 35000 HCME~ ECIS      
      10    50 C     A01    92.3 35,000_c~      4000 1 : Exper~ 35000 HCME~ ECIS      
      # i 14,030 more rows
      # i 2 more variables: SampleID <int>, Excluded <chr>

---

    Code
      vascr_subset(growth.df %>% mutate(Frequency = as.character(Frequency)),
      frequency = "4000")
    Output
      # A tibble: 14,040 x 12
          Time Unit  Well  Value Sample    Frequency Experiment cells line  Instrument
         <dbl> <chr> <chr> <dbl> <chr>         <dbl> <fct>      <chr> <chr> <chr>     
       1     5 C     A01   104.  35,000_c~      4000 1 : Exper~ 35000 HCME~ ECIS      
       2    10 C     A01    98.8 35,000_c~      4000 1 : Exper~ 35000 HCME~ ECIS      
       3    15 C     A01    92.3 35,000_c~      4000 1 : Exper~ 35000 HCME~ ECIS      
       4    20 C     A01    88.4 35,000_c~      4000 1 : Exper~ 35000 HCME~ ECIS      
       5    25 C     A01    86.9 35,000_c~      4000 1 : Exper~ 35000 HCME~ ECIS      
       6    30 C     A01    86.8 35,000_c~      4000 1 : Exper~ 35000 HCME~ ECIS      
       7    35 C     A01    86.7 35,000_c~      4000 1 : Exper~ 35000 HCME~ ECIS      
       8    40 C     A01    87.9 35,000_c~      4000 1 : Exper~ 35000 HCME~ ECIS      
       9    45 C     A01    90.0 35,000_c~      4000 1 : Exper~ 35000 HCME~ ECIS      
      10    50 C     A01    92.3 35,000_c~      4000 1 : Exper~ 35000 HCME~ ECIS      
      # i 14,030 more rows
      # i 2 more variables: SampleID <int>, Excluded <chr>

---

    Code
      vascr_subset(growth.df, experiment = 1)
    Output
      # A tibble: 46,215 x 12
          Time Unit  Well  Value Sample    Frequency Experiment cells line  Instrument
         <dbl> <chr> <chr> <dbl> <chr>         <dbl> <fct>      <chr> <chr> <chr>     
       1     5 Alpha A01    2.69 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       2     5 Alpha A02    2.89 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       3     5 Alpha A03    2.71 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       4     5 Alpha B01    2.52 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       5     5 Alpha B02    2.69 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       6     5 Alpha B03    2.34 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       7     5 Alpha C01    2.15 25,000_c~         0 1 : Exper~ 25000 HCME~ ECIS      
       8     5 Alpha C02    2.35 25,000_c~         0 1 : Exper~ 25000 HCME~ ECIS      
       9     5 Alpha C03    2.4  25,000_c~         0 1 : Exper~ 25000 HCME~ ECIS      
      10     5 Alpha D01    1.85 20,000_c~         0 1 : Exper~ 20000 HCME~ ECIS      
      # i 46,205 more rows
      # i 2 more variables: SampleID <int>, Excluded <chr>

---

    Code
      vascr_subset(growth.df, experiment = 1)
    Output
      # A tibble: 46,215 x 12
          Time Unit  Well  Value Sample    Frequency Experiment cells line  Instrument
         <dbl> <chr> <chr> <dbl> <chr>         <dbl> <fct>      <chr> <chr> <chr>     
       1     5 Alpha A01    2.69 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       2     5 Alpha A02    2.89 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       3     5 Alpha A03    2.71 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       4     5 Alpha B01    2.52 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       5     5 Alpha B02    2.69 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       6     5 Alpha B03    2.34 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       7     5 Alpha C01    2.15 25,000_c~         0 1 : Exper~ 25000 HCME~ ECIS      
       8     5 Alpha C02    2.35 25,000_c~         0 1 : Exper~ 25000 HCME~ ECIS      
       9     5 Alpha C03    2.4  25,000_c~         0 1 : Exper~ 25000 HCME~ ECIS      
      10     5 Alpha D01    1.85 20,000_c~         0 1 : Exper~ 20000 HCME~ ECIS      
      # i 46,205 more rows
      # i 2 more variables: SampleID <int>, Excluded <chr>

---

    Code
      vascr_subset(growth.df, instrument = "ECIS")
    Output
      # A tibble: 139,230 x 12
          Time Unit  Well  Value Sample    Frequency Experiment cells line  Instrument
         <dbl> <chr> <chr> <dbl> <chr>         <dbl> <fct>      <chr> <chr> <chr>     
       1     5 Alpha A01    2.69 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       2     5 Alpha A02    2.89 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       3     5 Alpha A03    2.71 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       4     5 Alpha B01    2.52 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       5     5 Alpha B02    2.69 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       6     5 Alpha B03    2.34 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       7     5 Alpha C01    2.15 25,000_c~         0 1 : Exper~ 25000 HCME~ ECIS      
       8     5 Alpha C02    2.35 25,000_c~         0 1 : Exper~ 25000 HCME~ ECIS      
       9     5 Alpha C03    2.4  25,000_c~         0 1 : Exper~ 25000 HCME~ ECIS      
      10     5 Alpha D01    1.85 20,000_c~         0 1 : Exper~ 20000 HCME~ ECIS      
      # i 139,220 more rows
      # i 2 more variables: SampleID <int>, Excluded <chr>

---

    Code
      vascr_subset(growth.df, unit = "Rb", sampleid = c(1:3))
    Output
      # A tibble: 1,053 x 12
          Time Unit  Well  Value Sample    Frequency Experiment cells line  Instrument
         <dbl> <fct> <chr> <dbl> <fct>         <dbl> <fct>      <chr> <chr> <chr>     
       1     5 Rb    A01       0 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       2     5 Rb    A02       0 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       3     5 Rb    A03       0 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       4     5 Rb    B01       0 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       5     5 Rb    B02       0 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       6     5 Rb    B03       0 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       7     5 Rb    C01       0 25,000_c~         0 1 : Exper~ 25000 HCME~ ECIS      
       8     5 Rb    C02       0 25,000_c~         0 1 : Exper~ 25000 HCME~ ECIS      
       9     5 Rb    C03       0 25,000_c~         0 1 : Exper~ 25000 HCME~ ECIS      
      10    10 Rb    A01       0 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
      # i 1,043 more rows
      # i 2 more variables: SampleID <int>, Excluded <chr>

---

    Code
      vascr_subset(growth.df, unit = "Rb", sampleid = c(8))
    Output
      # A tibble: 117 x 12
          Time Unit  Well  Value Sample    Frequency Experiment cells line  Instrument
         <dbl> <fct> <chr> <dbl> <fct>         <dbl> <fct>      <chr> <chr> <chr>     
       1     5 Rb    H07       0 0_cells ~         0 3 : Exper~ 0     HCME~ ECIS      
       2     5 Rb    H08       0 0_cells ~         0 3 : Exper~ 0     HCME~ ECIS      
       3     5 Rb    H09       0 0_cells ~         0 3 : Exper~ 0     HCME~ ECIS      
       4    10 Rb    H07       0 0_cells ~         0 3 : Exper~ 0     HCME~ ECIS      
       5    10 Rb    H08       0 0_cells ~         0 3 : Exper~ 0     HCME~ ECIS      
       6    10 Rb    H09       0 0_cells ~         0 3 : Exper~ 0     HCME~ ECIS      
       7    15 Rb    H07       0 0_cells ~         0 3 : Exper~ 0     HCME~ ECIS      
       8    15 Rb    H08       0 0_cells ~         0 3 : Exper~ 0     HCME~ ECIS      
       9    15 Rb    H09       0 0_cells ~         0 3 : Exper~ 0     HCME~ ECIS      
      10    20 Rb    H07       0 0_cells ~         0 3 : Exper~ 0     HCME~ ECIS      
      # i 107 more rows
      # i 2 more variables: SampleID <int>, Excluded <chr>

---

    Code
      vascr_subset(growth.df, subsample = 100)
    Output
      # A tibble: 3,570 x 12
          Time Unit  Well  Value Sample    Frequency Experiment cells line  Instrument
         <dbl> <chr> <chr> <dbl> <chr>         <dbl> <fct>      <chr> <chr> <chr>     
       1     5 Alpha A01    2.69 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       2     5 Alpha A02    2.89 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       3     5 Alpha A03    2.71 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       4     5 Alpha B01    2.52 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       5     5 Alpha B02    2.69 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       6     5 Alpha B03    2.34 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       7     5 Alpha C01    2.15 25,000_c~         0 1 : Exper~ 25000 HCME~ ECIS      
       8     5 Alpha C02    2.35 25,000_c~         0 1 : Exper~ 25000 HCME~ ECIS      
       9     5 Alpha C03    2.4  25,000_c~         0 1 : Exper~ 25000 HCME~ ECIS      
      10     5 Alpha D01    1.85 20,000_c~         0 1 : Exper~ 20000 HCME~ ECIS      
      # i 3,560 more rows
      # i 2 more variables: SampleID <int>, Excluded <chr>

---

    Code
      vascr_subset(growth.df, unit = "Rb", sampleid = 10)
    Message
      ! No data returned from dataset subset. Check your frequencies, times and units are present in the dataset
    Output
      # A tibble: 0 x 12
      # i 12 variables: Time <dbl>, Unit <fct>, Well <chr>, Value <dbl>,
      #   Sample <fct>, Frequency <dbl>, Experiment <fct>, cells <chr>, line <chr>,
      #   Instrument <chr>, SampleID <int>, Excluded <chr>

---

    Code
      vascr_exclude(growth.df, c("A01", "E01"))
    Output
      # A tibble: 142,270 x 12
          Time Unit  Well  Value Sample    Frequency Experiment cells line  Instrument
         <dbl> <chr> <chr> <dbl> <chr>         <dbl> <fct>      <chr> <chr> <chr>     
       1     0 Alpha A02      NA 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       2     0 Alpha A03      NA 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       3     0 Alpha B01      NA 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       4     0 Alpha B02      NA 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       5     0 Alpha B03      NA 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       6     0 Alpha C01      NA 25,000_c~         0 1 : Exper~ 25000 HCME~ ECIS      
       7     0 Alpha C02      NA 25,000_c~         0 1 : Exper~ 25000 HCME~ ECIS      
       8     0 Alpha C03      NA 25,000_c~         0 1 : Exper~ 25000 HCME~ ECIS      
       9     0 Alpha D01      NA 20,000_c~         0 1 : Exper~ 20000 HCME~ ECIS      
      10     0 Alpha D02      NA 20,000_c~         0 1 : Exper~ 20000 HCME~ ECIS      
      # i 142,260 more rows
      # i 2 more variables: SampleID <int>, Excluded <chr>

---

    Code
      vascr_exclude(growth.df, c("A01", "E01"), 1)
    Output
      # A tibble: 142,270 x 12
          Time Unit  Well  Value Sample    Frequency Experiment cells line  Instrument
         <dbl> <chr> <chr> <dbl> <chr>         <dbl> <fct>      <chr> <chr> <chr>     
       1     0 Alpha A02      NA 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       2     0 Alpha A03      NA 35,000_c~         0 1 : Exper~ 35000 HCME~ ECIS      
       3     0 Alpha B01      NA 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       4     0 Alpha B02      NA 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       5     0 Alpha B03      NA 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       6     0 Alpha C01      NA 25,000_c~         0 1 : Exper~ 25000 HCME~ ECIS      
       7     0 Alpha C02      NA 25,000_c~         0 1 : Exper~ 25000 HCME~ ECIS      
       8     0 Alpha C03      NA 25,000_c~         0 1 : Exper~ 25000 HCME~ ECIS      
       9     0 Alpha D01      NA 20,000_c~         0 1 : Exper~ 20000 HCME~ ECIS      
      10     0 Alpha D02      NA 20,000_c~         0 1 : Exper~ 20000 HCME~ ECIS      
      # i 142,260 more rows
      # i 2 more variables: SampleID <int>, Excluded <chr>

---

    Code
      vascr_replace_sample(growth.df, "35,000_cells + HCMEC D3_line",
        "35 Thousand Cells")
    Output
      # A tibble: 146,370 x 12
          Time Unit  Well  Value Sample    Frequency Experiment cells line  Instrument
         <dbl> <chr> <chr> <dbl> <chr>         <dbl> <fct>      <chr> <chr> <chr>     
       1     0 Alpha A01      NA 35 Thous~         0 1 : Exper~ 35000 HCME~ ECIS      
       2     0 Alpha A02      NA 35 Thous~         0 1 : Exper~ 35000 HCME~ ECIS      
       3     0 Alpha A03      NA 35 Thous~         0 1 : Exper~ 35000 HCME~ ECIS      
       4     0 Alpha B01      NA 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       5     0 Alpha B02      NA 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       6     0 Alpha B03      NA 30,000_c~         0 1 : Exper~ 30000 HCME~ ECIS      
       7     0 Alpha C01      NA 25,000_c~         0 1 : Exper~ 25000 HCME~ ECIS      
       8     0 Alpha C02      NA 25,000_c~         0 1 : Exper~ 25000 HCME~ ECIS      
       9     0 Alpha C03      NA 25,000_c~         0 1 : Exper~ 25000 HCME~ ECIS      
      10     0 Alpha D01      NA 20,000_c~         0 1 : Exper~ 20000 HCME~ ECIS      
      # i 146,360 more rows
      # i 2 more variables: SampleID <int>, Excluded <chr>

---

    Code
      renamed
    Output
      # A tibble: 51,480 x 13
          Time Unit  Well   Value Frequency Experiment cells line  Instrument SampleID
         <dbl> <chr> <chr>  <dbl>     <dbl> <fct>      <chr> <chr> <chr>         <int>
       1     5 Alpha D01     1.85         0 1 : Exper~ 20000 HCME~ ECIS              4
       2     5 Alpha D02     2.02         0 1 : Exper~ 20000 HCME~ ECIS              4
       3     5 Alpha D03     2.05         0 1 : Exper~ 20000 HCME~ ECIS              4
       4     5 Alpha F01     1.34         0 1 : Exper~ 10000 HCME~ ECIS              6
       5     5 Alpha F02     0            0 1 : Exper~ 10000 HCME~ ECIS              6
       6     5 Alpha F03     1.49         0 1 : Exper~ 10000 HCME~ ECIS              6
       7     5 Cm    D01    85.6          0 1 : Exper~ 20000 HCME~ ECIS              4
       8     5 Cm    D02    86.1          0 1 : Exper~ 20000 HCME~ ECIS              4
       9     5 Cm    D03    75.0          0 1 : Exper~ 20000 HCME~ ECIS              4
      10     5 Cm    F01   167.           0 1 : Exper~ 10000 HCME~ ECIS              6
      # i 51,470 more rows
      # i 3 more variables: Excluded <chr>, Sample <fct>, Original_Sample <fct>

