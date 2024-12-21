# Check duplicate

    Code
      vascr_check_duplicate(map_4, "Row")
    Condition
      Warning in `vascr_check_duplicate()`:
      Row [ A ]   defined more than once 
      
      # A tibble: 2 x 5
        Row    Freq SampleID Column Sample                       
        <chr> <int>    <dbl> <chr>  <chr>                        
      1 A         2        1 1 2 3  10 nM Treatment 1 + 1nm water
      2 A         2        3 1 2 3  10 nM Treatment 2 + 1nm water
    Output
      NULL

---

    Code
      vascr_check_duplicate(map_5, "Sample")
    Condition
      Warning in `vascr_check_duplicate()`:
      Sample [ 10 nM Treatment 1 + 1nm water ]   defined more than once 
      
      # A tibble: 2 x 5
        Sample                         Freq SampleID Row   Column
        <chr>                         <int>    <dbl> <chr> <chr> 
      1 10 nM Treatment 1 + 1nm water     2        1 A     1 2 3 
      2 10 nM Treatment 1 + 1nm water     2        3 C     1 2 3 
    Output
      NULL

---

    Code
      vascr_check_duplicate(map_5, "Row")
    Output
      NULL

# Check col exists

    Code
      vascr_check_col_exists(map_4, "Row")
    Output
      [1] TRUE

---

    Code
      vascr_check_col_exists(map_4, "Not_A_Col")
    Condition
      Warning in `vascr_check_col_exists()`:
      Not_A_Col not found in dataframe. Please check
    Output
      [1] FALSE

