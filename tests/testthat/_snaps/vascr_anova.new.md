# Can make a significance table

    Code
      vascr_make_significance_table(growth.df, 50, "R", 4000, 0.95)
    Output
      # A tibble: 8 x 2
        Sample                       Label                                            
        <chr>                        <chr>                                            
      1 0_cells x HCMEC D3_line      "15,000_cells x HCMEC D3_line **\n20,000_cells x~
      2 10,000_cells x HCMEC D3_line "25,000_cells x HCMEC D3_line **\n30,000_cells x~
      3 15,000_cells x HCMEC D3_line "0_cells x HCMEC D3_line **\n30,000_cells x HCME~
      4 20,000_cells x HCMEC D3_line "0_cells x HCMEC D3_line ***\n30,000_cells x HCM~
      5 25,000_cells x HCMEC D3_line "0_cells x HCMEC D3_line ****\n10,000_cells x HC~
      6 30,000_cells x HCMEC D3_line "0_cells x HCMEC D3_line ****\n10,000_cells x HC~
      7 35,000_cells x HCMEC D3_line "0_cells x HCMEC D3_line ****\n10,000_cells x HC~
      8 5,000_cells x HCMEC D3_line  "20,000_cells x HCMEC D3_line *\n25,000_cells x ~

# Vascr LM

    Code
      vascr_lm(growth.df, "R", 4000, 100)
    Output
      
      Call:
      lm(formula = formula, data = data.df)
      
      Coefficients:
                             (Intercept)           Experiment2 : Experiment2  
                                  302.97                              -81.22  
               Experiment3 : Experiment3  Sample10,000_cells + HCMEC D3_line  
                                 -123.63                              318.87  
      Sample15,000_cells + HCMEC D3_line  Sample20,000_cells + HCMEC D3_line  
                                  366.04                              365.43  
      Sample25,000_cells + HCMEC D3_line  Sample30,000_cells + HCMEC D3_line  
                                  357.85                              349.05  
      Sample35,000_cells + HCMEC D3_line   Sample5,000_cells + HCMEC D3_line  
                                  320.43                              140.83  
      

# Vascr_residuals

    Code
      vascr_residuals(growth.df, "R", "4000", 100)
    Output
                1           2           3           4           5           6 
      -71.2600254  15.1556080  56.1044174  43.5198942   0.2053120 -43.7252062 
                7           8           9          10          11          12 
       41.2513697 -11.8259343 -29.4254354  29.3639323 -31.1078063   1.7438740 
               13          14          15          16          17          18 
       17.5040807 -16.5831750  -0.9209057   3.8446770  -4.2829199   0.4382429 
               19          20          21          22          23          24 
      -21.3740220  -1.3609699  22.7349919 -42.8499065  49.7998853  -6.9499789 

# Vascr Shapiro test checks

    Code
      vascr_shapiro(growth.df, "R", 4000, 100)
    Output
      
      	Shapiro-Wilk normality test
      
      data:  aov_residuals
      W = 0.97874, p-value = 0.8716
      

# Levene test

    Code
      vascr_levene(growth.df, "R", 4000, 100)
    Output
      # A tibble: 1 x 4
          df1   df2 statistic     p
        <int> <int>     <dbl> <dbl>
      1     7    16     0.484 0.832

# Tukey tests

    Code
      vascr_tukey(growth.df, "R", 4000, 100)
    Output
      # A tibble: 8 x 2
        Sample                       Label                                            
        <chr>                        <chr>                                            
      1 0_cells x HCMEC D3_line      "10,000_cells x HCMEC D3_line ****\n15,000_cells~
      2 10,000_cells x HCMEC D3_line "0_cells x HCMEC D3_line ****\n5,000_cells x HCM~
      3 15,000_cells x HCMEC D3_line "0_cells x HCMEC D3_line ****\n5,000_cells x HCM~
      4 20,000_cells x HCMEC D3_line "0_cells x HCMEC D3_line ****\n5,000_cells x HCM~
      5 25,000_cells x HCMEC D3_line "0_cells x HCMEC D3_line ****\n5,000_cells x HCM~
      6 30,000_cells x HCMEC D3_line "0_cells x HCMEC D3_line ****\n5,000_cells x HCM~
      7 35,000_cells x HCMEC D3_line "0_cells x HCMEC D3_line ****\n5,000_cells x HCM~
      8 5,000_cells x HCMEC D3_line  "0_cells x HCMEC D3_line *\n10,000_cells x HCMEC~

---

    Code
      vascr_tukey(growth.df, "R", 4000, 100, raw = TRUE)
    Output
      # A tibble: 8 x 2
        Sample                       Label                                            
        <chr>                        <chr>                                            
      1 0_cells x HCMEC D3_line      "10,000_cells x HCMEC D3_line ****\n15,000_cells~
      2 10,000_cells x HCMEC D3_line "0_cells x HCMEC D3_line ****\n5,000_cells x HCM~
      3 15,000_cells x HCMEC D3_line "0_cells x HCMEC D3_line ****\n5,000_cells x HCM~
      4 20,000_cells x HCMEC D3_line "0_cells x HCMEC D3_line ****\n5,000_cells x HCM~
      5 25,000_cells x HCMEC D3_line "0_cells x HCMEC D3_line ****\n5,000_cells x HCM~
      6 30,000_cells x HCMEC D3_line "0_cells x HCMEC D3_line ****\n5,000_cells x HCM~
      7 35,000_cells x HCMEC D3_line "0_cells x HCMEC D3_line ****\n5,000_cells x HCM~
      8 5,000_cells x HCMEC D3_line  "0_cells x HCMEC D3_line *\n10,000_cells x HCMEC~

