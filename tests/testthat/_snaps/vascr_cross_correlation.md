# ccf functions work

    Code
      vascr_cc(data.df)
    Output
      # A tibble: 2 x 11
      # Groups:   SampleID 1, Sample 1, Experiment 1 [1]
        `Well 1` `SampleID 1` `Sample 1`            `Experiment 1` `values 1` `Well 2`
        <chr>           <int> <fct>                 <fct>          <list>     <chr>   
      1 A02                 1 35,000_cells + HCMEC~ 1 : Experimen~ <dbl [2]>  D01     
      2 A03                 1 35,000_cells + HCMEC~ 1 : Experimen~ <dbl [2]>  D01     
      # i 5 more variables: `SampleID 2` <int>, `Sample 2` <fct>,
      #   `Experiment 2` <fct>, `values 2` <list>, cc <dbl>

---

    Code
      cc_data
    Output
      # A tibble: 81 x 11
      # Groups:   SampleID 1, Sample 1, Experiment 1 [6]
         `Well 1` `SampleID 1` `Sample 1`           `Experiment 1` `values 1` `Well 2`
         <chr>           <int> <fct>                <fct>          <list>     <chr>   
       1 A01                 1 35,000_cells + HCME~ 1 : Experimen~ <dbl [4]>  D01     
       2 A01                 1 35,000_cells + HCME~ 1 : Experimen~ <dbl [4]>  D02     
       3 A01                 1 35,000_cells + HCME~ 1 : Experimen~ <dbl [4]>  D03     
       4 A01                 1 35,000_cells + HCME~ 1 : Experimen~ <dbl [4]>  G01     
       5 A01                 1 35,000_cells + HCME~ 1 : Experimen~ <dbl [4]>  G02     
       6 A01                 1 35,000_cells + HCME~ 1 : Experimen~ <dbl [4]>  G03     
       7 A02                 1 35,000_cells + HCME~ 1 : Experimen~ <dbl [4]>  D01     
       8 A02                 1 35,000_cells + HCME~ 1 : Experimen~ <dbl [4]>  D02     
       9 A02                 1 35,000_cells + HCME~ 1 : Experimen~ <dbl [4]>  D03     
      10 A02                 1 35,000_cells + HCME~ 1 : Experimen~ <dbl [4]>  G01     
      # i 71 more rows
      # i 5 more variables: `SampleID 2` <int>, `Sample 2` <fct>,
      #   `Experiment 2` <fct>, `values 2` <list>, cc <dbl>

---

    Code
      vascr_summarise_cc(cc_data, "experiments")
    Output
      # A tibble: 9 x 8
      # Groups:   Sample 1, Sample 2, SampleID 1, SampleID 2, Experiment 1 [9]
        `Sample 1`  `Sample 2` `SampleID 1` `SampleID 2` `Experiment 1` `Experiment 2`
        <fct>       <fct>             <int>        <int> <fct>          <fct>         
      1 35,000_cel~ 20,000_ce~            1            4 1 : Experimen~ 1 : Experimen~
      2 35,000_cel~ 20,000_ce~            1            4 2 : Experimen~ 2 : Experimen~
      3 35,000_cel~ 20,000_ce~            1            4 3 : Experimen~ 3 : Experimen~
      4 35,000_cel~ 5,000_cel~            1            7 1 : Experimen~ 1 : Experimen~
      5 35,000_cel~ 5,000_cel~            1            7 2 : Experimen~ 2 : Experimen~
      6 35,000_cel~ 5,000_cel~            1            7 3 : Experimen~ 3 : Experimen~
      7 20,000_cel~ 5,000_cel~            4            7 1 : Experimen~ 1 : Experimen~
      8 20,000_cel~ 5,000_cel~            4            7 2 : Experimen~ 2 : Experimen~
      9 20,000_cel~ 5,000_cel~            4            7 3 : Experimen~ 3 : Experimen~
      # i 2 more variables: cc <dbl>, n <int>

---

    Code
      vascr_summarise_cc(cc_data, "summary")
    Output
      # A tibble: 3 x 6
      # Groups:   Sample 1 [2]
        `Sample 1`                   `Sample 2`               ccsem    cc totaln title
        <fct>                        <fct>                    <dbl> <dbl>  <int> <chr>
      1 35,000_cells + HCMEC D3_line 20,000_cells + HCMEC ~ 1.09e-3 0.995     27 "35,~
      2 35,000_cells + HCMEC D3_line 5,000_cells + HCMEC D~ 1.41e-3 0.994     27 "35,~
      3 20,000_cells + HCMEC D3_line 5,000_cells + HCMEC D~ 8.71e-4 0.997     27 "20,~

