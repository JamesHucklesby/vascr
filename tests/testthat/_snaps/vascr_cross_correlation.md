# ccf functions work

    Code
      vascr_cc(data.df)
    Output
      # A tibble: 2 x 10
      # Rowwise:  Experiment
        Well.x SampleID.x Sample.x      Experiment values.x Well.y SampleID.y Sample.y
        <chr>       <int> <fct>         <fct>      <list>   <chr>       <int> <fct>   
      1 A02             1 35,000_cells~ 1 : Exper~ <dbl>    D01             4 20,000_~
      2 A03             1 35,000_cells~ 1 : Exper~ <dbl>    D01             4 20,000_~
      # i 2 more variables: values.y <list>, cc <dbl>

---

    Code
      cc_data
    Output
      # A tibble: 54 x 10
      # Rowwise:  Experiment
         Well.x SampleID.x Sample.x     Experiment values.x Well.y SampleID.y Sample.y
         <chr>       <int> <fct>        <fct>      <list>   <chr>       <int> <fct>   
       1 A01             1 35,000_cell~ 1 : Exper~ <dbl>    D01             4 20,000_~
       2 A01             1 35,000_cell~ 1 : Exper~ <dbl>    D02             4 20,000_~
       3 A01             1 35,000_cell~ 1 : Exper~ <dbl>    D03             4 20,000_~
       4 A01             1 35,000_cell~ 1 : Exper~ <dbl>    G01             7 5,000_c~
       5 A01             1 35,000_cell~ 1 : Exper~ <dbl>    G02             7 5,000_c~
       6 A01             1 35,000_cell~ 1 : Exper~ <dbl>    G03             7 5,000_c~
       7 A02             1 35,000_cell~ 1 : Exper~ <dbl>    D01             4 20,000_~
       8 A02             1 35,000_cell~ 1 : Exper~ <dbl>    D02             4 20,000_~
       9 A02             1 35,000_cell~ 1 : Exper~ <dbl>    D03             4 20,000_~
      10 A02             1 35,000_cell~ 1 : Exper~ <dbl>    G01             7 5,000_c~
      # i 44 more rows
      # i 2 more variables: values.y <list>, cc <dbl>

---

    Code
      cc_data
    Output
      # A tibble: 81 x 10
      # Rowwise:  Experiment
         Well.x SampleID.x Sample.x     Experiment values.x Well.y SampleID.y Sample.y
         <chr>       <int> <fct>        <fct>      <list>   <chr>       <int> <fct>   
       1 A01             1 35,000_cell~ 1 : Exper~ <dbl>    D01             4 20,000_~
       2 A01             1 35,000_cell~ 1 : Exper~ <dbl>    D02             4 20,000_~
       3 A01             1 35,000_cell~ 1 : Exper~ <dbl>    D03             4 20,000_~
       4 A01             1 35,000_cell~ 1 : Exper~ <dbl>    G01             7 5,000_c~
       5 A01             1 35,000_cell~ 1 : Exper~ <dbl>    G02             7 5,000_c~
       6 A01             1 35,000_cell~ 1 : Exper~ <dbl>    G03             7 5,000_c~
       7 A02             1 35,000_cell~ 1 : Exper~ <dbl>    D01             4 20,000_~
       8 A02             1 35,000_cell~ 1 : Exper~ <dbl>    D02             4 20,000_~
       9 A02             1 35,000_cell~ 1 : Exper~ <dbl>    D03             4 20,000_~
      10 A02             1 35,000_cell~ 1 : Exper~ <dbl>    G01             7 5,000_c~
      # i 71 more rows
      # i 2 more variables: values.y <list>, cc <dbl>

---

    Code
      cc_data
    Output
      # A tibble: 81 x 10
      # Rowwise:  Experiment
         Well.x SampleID.x Sample.x     Experiment values.x Well.y SampleID.y Sample.y
         <chr>       <int> <fct>        <fct>      <list>   <chr>       <int> <fct>   
       1 A01             1 35,000_cell~ 1 : Exper~ <dbl>    D01             4 20,000_~
       2 A01             1 35,000_cell~ 1 : Exper~ <dbl>    D02             4 20,000_~
       3 A01             1 35,000_cell~ 1 : Exper~ <dbl>    D03             4 20,000_~
       4 A01             1 35,000_cell~ 1 : Exper~ <dbl>    G01             7 5,000_c~
       5 A01             1 35,000_cell~ 1 : Exper~ <dbl>    G02             7 5,000_c~
       6 A01             1 35,000_cell~ 1 : Exper~ <dbl>    G03             7 5,000_c~
       7 A02             1 35,000_cell~ 1 : Exper~ <dbl>    D01             4 20,000_~
       8 A02             1 35,000_cell~ 1 : Exper~ <dbl>    D02             4 20,000_~
       9 A02             1 35,000_cell~ 1 : Exper~ <dbl>    D03             4 20,000_~
      10 A02             1 35,000_cell~ 1 : Exper~ <dbl>    G01             7 5,000_c~
      # i 71 more rows
      # i 2 more variables: values.y <list>, cc <dbl>

---

    Code
      vascr_summarise_cc(cc_data, "experiments")
    Output
      # A tibble: 9 x 7
      # Groups:   Sample.x, Sample.y, SampleID.x, SampleID.y [3]
        Sample.x                 Sample.y SampleID.x SampleID.y Experiment    cc     n
        <fct>                    <fct>         <int>      <int> <fct>      <dbl> <int>
      1 35,000_cells + HCMEC D3~ 20,000_~          1          4 1 : Exper~ 0.998     9
      2 35,000_cells + HCMEC D3~ 20,000_~          1          4 2 : Exper~ 0.996     9
      3 35,000_cells + HCMEC D3~ 20,000_~          1          4 3 : Exper~ 0.992     9
      4 35,000_cells + HCMEC D3~ 5,000_c~          1          7 1 : Exper~ 0.997     9
      5 35,000_cells + HCMEC D3~ 5,000_c~          1          7 2 : Exper~ 0.996     9
      6 35,000_cells + HCMEC D3~ 5,000_c~          1          7 3 : Exper~ 0.989     9
      7 20,000_cells + HCMEC D3~ 5,000_c~          4          7 1 : Exper~ 0.998     9
      8 20,000_cells + HCMEC D3~ 5,000_c~          4          7 2 : Exper~ 0.994     9
      9 20,000_cells + HCMEC D3~ 5,000_c~          4          7 3 : Exper~ 0.998     9

---

    Code
      vascr_summarise_cc(cc_data, "summary")
    Output
      # A tibble: 3 x 6
      # Groups:   Sample.x [2]
        Sample.x                     Sample.y                 ccsem    cc totaln title
        <fct>                        <fct>                    <dbl> <dbl>  <int> <chr>
      1 35,000_cells + HCMEC D3_line 20,000_cells + HCMEC ~ 1.09e-3 0.995     27 "35,~
      2 35,000_cells + HCMEC D3_line 5,000_cells + HCMEC D~ 1.41e-3 0.994     27 "35,~
      3 20,000_cells + HCMEC D3_line 5,000_cells + HCMEC D~ 8.71e-4 0.997     27 "20,~

