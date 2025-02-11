# Samples work

    Code
      vascr_import_map(map_1)
    Output
      # A tibble: 12 x 3
         Sample                         SampleID Well 
         <chr>                             <int> <chr>
       1 10 nM Treatment 1 + 1nm water         1 A01  
       2 10 nM Treatment 1 + 1nm water         1 A02  
       3 10 nM Treatment 1 + 1nm water         1 A03  
       4 100 nM Treatment 1 + 1nm water        2 B01  
       5 100 nM Treatment 1 + 1nm water        2 B02  
       6 100 nM Treatment 1 + 1nm water        2 B03  
       7 10 nM Treatment 2 + 1nm water         3 C04  
       8 10 nM Treatment 2 + 1nm water         3 C05  
       9 10 nM Treatment 2 + 1nm water         3 C06  
      10 100 nM Treatment 2 + 1nm water        4 D01  
      11 100 nM Treatment 2 + 1nm water        4 D02  
      12 100 nM Treatment 2 + 1nm water        4 D03  

---

    Code
      vascr_import_map(map_2)
    Output
      # A tibble: 12 x 3
         Well  Sample                         SampleID
         <chr> <chr>                             <int>
       1 A01   10 nM Treatment 1 + 1nm water         1
       2 A02   10 nM Treatment 1 + 1nm water         1
       3 A03   10 nM Treatment 1 + 1nm water         1
       4 B01   100 nM Treatment 1 + 1nm water        2
       5 B02   100 nM Treatment 1 + 1nm water        2
       6 B03   100 nM Treatment 1 + 1nm water        2
       7 C01   10 nM Treatment 2 + 1nm water         3
       8 C02   10 nM Treatment 2 + 1nm water         3
       9 C03   10 nM Treatment 2 + 1nm water         3
      10 C01   100 nM Treatment 2 + 1nm water        4
      11 C02   100 nM Treatment 2 + 1nm water        4
      12 C03   100 nM Treatment 2 + 1nm water        4

---

    Either `Row` and `Column' or `Well` must be specified in the input file

---

    Code
      vascr_import_map(map_4)
    Output
      # A tibble: 12 x 3
         SampleID Sample                         Well 
            <dbl> <chr>                          <chr>
       1        1 10 nM Treatment 1 + 1nm water  A01  
       2        1 10 nM Treatment 1 + 1nm water  A02  
       3        1 10 nM Treatment 1 + 1nm water  A03  
       4        2 100 nM Treatment 1 + 1nm water B01  
       5        2 100 nM Treatment 1 + 1nm water B02  
       6        2 100 nM Treatment 1 + 1nm water B03  
       7        3 10 nM Treatment 2 + 1nm water  A01  
       8        3 10 nM Treatment 2 + 1nm water  A02  
       9        3 10 nM Treatment 2 + 1nm water  A03  
      10        4 100 nM Treatment 2 + 1nm water D01  
      11        4 100 nM Treatment 2 + 1nm water D02  
      12        4 100 nM Treatment 2 + 1nm water D03  

---

    Code
      vascr_import_map(map_5)
    Output
      # A tibble: 12 x 3
         SampleID Sample                         Well 
            <dbl> <chr>                          <chr>
       1        1 10 nM Treatment 1 + 1nm water  A01  
       2        1 10 nM Treatment 1 + 1nm water  A02  
       3        1 10 nM Treatment 1 + 1nm water  A03  
       4        2 100 nM Treatment 1 + 1nm water B01  
       5        2 100 nM Treatment 1 + 1nm water B02  
       6        2 100 nM Treatment 1 + 1nm water B03  
       7        3 10 nM Treatment 1 + 1nm water  C01  
       8        3 10 nM Treatment 1 + 1nm water  C02  
       9        3 10 nM Treatment 1 + 1nm water  C03  
      10        4 100 nM Treatment 2 + 1nm water D01  
      11        4 100 nM Treatment 2 + 1nm water D02  
      12        4 100 nM Treatment 2 + 1nm water D03  

---

    Code
      vascr_import_map(map_6)
    Output
      # A tibble: 12 x 3
         SampleID Sample                         Well 
            <dbl> <chr>                          <chr>
       1        1 10 nM Treatment 1 + 1nm water  A01  
       2        1 10 nM Treatment 1 + 1nm water  A02  
       3        1 10 nM Treatment 1 + 1nm water  A03  
       4        2 100 nM Treatment 1 + 1nm water B01  
       5        2 100 nM Treatment 1 + 1nm water B02  
       6        2 100 nM Treatment 1 + 1nm water B03  
       7        3 10 nM Treatment 2 + 1nm water  C04  
       8        3 10 nM Treatment 2 + 1nm water  C05  
       9        3 10 nM Treatment 2 + 1nm water  C06  
      10        4 100 nM Treatment 2 + 1nm water D01  
      11        4 100 nM Treatment 2 + 1nm water D02  
      12        4 100 nM Treatment 2 + 1nm water D03  

---

    Code
      vascr_import_map(map_7)
    Output
      # A tibble: 12 x 3
         SampleID Sample                                          Well 
            <dbl> <chr>                                           <chr>
       1        1 10 nM Treatment 1 + 1nm water + 6nm Treatment 2 A01  
       2        1 10 nM Treatment 1 + 1nm water + 6nm Treatment 2 A02  
       3        1 10 nM Treatment 1 + 1nm water + 6nm Treatment 2 A03  
       4        2 100 nM Treatment 1 + 1nm water                  B01  
       5        2 100 nM Treatment 1 + 1nm water                  B02  
       6        2 100 nM Treatment 1 + 1nm water                  B03  
       7        3 10 nM Treatment 2 + 1nm water                   C04  
       8        3 10 nM Treatment 2 + 1nm water                   C05  
       9        3 10 nM Treatment 2 + 1nm water                   C06  
      10        4 100 nM Treatment 2 + 1nm water                  D01  
      11        4 100 nM Treatment 2 + 1nm water                  D02  
      12        4 100 nM Treatment 2 + 1nm water                  D03  

---

    Code
      vascr_explode(growth.df)
    Output
      # A tibble: 146,370 x 14
          Time Unit  Well  Value Sample  Frequency Experiment cells.x line  Instrument
         <dbl> <chr> <chr> <dbl> <chr>       <dbl> <fct>      <chr>   <chr> <chr>     
       1     0 Alpha A01      NA 35,000~         0 1 : Exper~ 35000   HCME~ ECIS      
       2     0 Alpha A02      NA 35,000~         0 1 : Exper~ 35000   HCME~ ECIS      
       3     0 Alpha A03      NA 35,000~         0 1 : Exper~ 35000   HCME~ ECIS      
       4     0 Alpha B01      NA 30,000~         0 1 : Exper~ 30000   HCME~ ECIS      
       5     0 Alpha B02      NA 30,000~         0 1 : Exper~ 30000   HCME~ ECIS      
       6     0 Alpha B03      NA 30,000~         0 1 : Exper~ 30000   HCME~ ECIS      
       7     0 Alpha C01      NA 25,000~         0 1 : Exper~ 25000   HCME~ ECIS      
       8     0 Alpha C02      NA 25,000~         0 1 : Exper~ 25000   HCME~ ECIS      
       9     0 Alpha C03      NA 25,000~         0 1 : Exper~ 25000   HCME~ ECIS      
      10     0 Alpha D01      NA 20,000~         0 1 : Exper~ 20000   HCME~ ECIS      
      # i 146,360 more rows
      # i 4 more variables: SampleID <int>, Excluded <chr>, cells.y <chr>,
      #   D3_line <chr>

---

    Code
      vascr_import_map(lookup)
    Output
      # A tibble: 6 x 5
        SampleID Sample                        Well  Vehicle HCMVEC
           <int> <chr>                         <chr> <chr>   <chr> 
      1        1 Water Vehicle + 80,000 HCMVEC A01   Water   80,000
      2        2 Water Vehicle + 80,000 HCMVEC B01   Water   80,000
      3        3 Water Vehicle + 80,000 HCMVEC C01   Water   80,000
      4        4 Water Vehicle + 20,000 HCMVEC E02   Water   20,000
      5        5 Water Vehicle + 20,000 HCMVEC F02   Water   20,000
      6        6 Water Vehicle + 20,000 HCMVEC G02   Water   20,000

