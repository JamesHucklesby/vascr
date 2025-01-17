# Linear model

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
      

---

    Code
      vascr_lm(growth.df, "Rb", 0, 25)
    Output
      
      Call:
      lm(formula = formula, data = data.df)
      
      Coefficients:
                             (Intercept)           Experiment2 : Experiment2  
                                 0.02000                             0.02048  
               Experiment3 : Experiment3  Sample10,000_cells + HCMEC D3_line  
                                -0.02000                            -0.02016  
      Sample15,000_cells + HCMEC D3_line  Sample20,000_cells + HCMEC D3_line  
                                -0.02016                            -0.02016  
      Sample25,000_cells + HCMEC D3_line  Sample30,000_cells + HCMEC D3_line  
                                -0.02016                            -0.02016  
      Sample35,000_cells + HCMEC D3_line   Sample5,000_cells + HCMEC D3_line  
                                 0.12095                            -0.02016  
      

# Significance table

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

---

    Code
      vascr_make_significance_table(growth.df, 50, "R", 4000, 0.95, format = "Tukey_data")
    Output
      # A tibble: 31 x 9
         term       group1       group2 null.value estimate conf.low conf.high   p.adj
       * <chr>      <chr>        <chr>       <dbl>    <dbl>    <dbl>     <dbl>   <dbl>
       1 Experiment 1 : Experim~ 2 : E~          0    -24.8    -79.3      29.8 4.79e-1
       2 Experiment 1 : Experim~ 3 : E~          0    -91.8   -146.      -37.3 1.61e-3
       3 Experiment 2 : Experim~ 3 : E~          0    -67.1   -122.      -12.6 1.59e-2
       4 Sample     0_cells x H~ 10,00~          0    109.     -11.1     229.  8.84e-2
       5 Sample     0_cells x H~ 15,00~          0    158.      37.9     278.  6.78e-3
       6 Sample     0_cells x H~ 20,00~          0    202.      82.2     322.  7   e-4
       7 Sample     0_cells x H~ 25,00~          0    268.     148.      388.  3.4 e-5
       8 Sample     0_cells x H~ 30,00~          0    344.     224.      464.  1.76e-6
       9 Sample     0_cells x H~ 35,00~          0    424.     304.      544.  1.25e-7
      10 Sample     0_cells x H~ 5,000~          0     54.9    -65.1     175.  7.35e-1
      # i 21 more rows
      # i 1 more variable: p.adj.signif <chr>

# Residuals

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

# Shapiro Test

    Code
      vascr_shapiro(growth.df, "R", 4000, 100)
    Output
      
      	Shapiro-Wilk normality test
      
      data:  aov_residuals
      W = 0.97874, p-value = 0.8716
      

# Levene Test

    Code
      vascr_levene(growth.df, "R", 4000, 100)
    Output
      # A tibble: 1 x 4
          df1   df2 statistic     p
        <int> <int>     <dbl> <dbl>
      1     7    16     0.484 0.832

# Tukey Test

    Code
      vascr_tukey(growth.df, "R", 4000, 100)
    Output
      # A tibble: 31 x 9
         term       group1       group2 null.value estimate conf.low conf.high   p.adj
         <chr>      <chr>        <chr>       <dbl>    <dbl>    <dbl>     <dbl>   <dbl>
       1 Experiment 1 : Experim~ 2 : E~          0    -81.2   -134.      -28.5 3.33e-3
       2 Experiment 1 : Experim~ 3 : E~          0   -124.    -176.      -70.9 7.24e-5
       3 Experiment 2 : Experim~ 3 : E~          0    -42.4    -95.2      10.4 1.25e-1
       4 Sample     0_cells x H~ 10,00~          0    319.     203.      435.  2.99e-6
       5 Sample     0_cells x H~ 15,00~          0    366.     250.      482.  5.41e-7
       6 Sample     0_cells x H~ 20,00~          0    365.     249.      482.  5.53e-7
       7 Sample     0_cells x H~ 25,00~          0    358.     242.      474.  7.19e-7
       8 Sample     0_cells x H~ 30,00~          0    349.     233.      465.  9.8 e-7
       9 Sample     0_cells x H~ 35,00~          0    320.     204.      437.  2.81e-6
      10 Sample     0_cells x H~ 5,000~          0    141.      24.7     257.  1.3 e-2
      # i 21 more rows
      # i 1 more variable: p.adj.signif <chr>

---

    Code
      vascr_tukey(growth.df, "R", 4000, 100, raw = TRUE)
    Output
      # A tibble: 31 x 9
         term       group1       group2 null.value estimate conf.low conf.high   p.adj
       * <chr>      <chr>        <chr>       <dbl>    <dbl>    <dbl>     <dbl>   <dbl>
       1 Experiment 1 : Experim~ 2 : E~          0    -81.2   -134.      -28.5 3.33e-3
       2 Experiment 1 : Experim~ 3 : E~          0   -124.    -176.      -70.9 7.24e-5
       3 Experiment 2 : Experim~ 3 : E~          0    -42.4    -95.2      10.4 1.25e-1
       4 Sample     0_cells x H~ 10,00~          0    319.     203.      435.  2.99e-6
       5 Sample     0_cells x H~ 15,00~          0    366.     250.      482.  5.41e-7
       6 Sample     0_cells x H~ 20,00~          0    365.     249.      482.  5.53e-7
       7 Sample     0_cells x H~ 25,00~          0    358.     242.      474.  7.19e-7
       8 Sample     0_cells x H~ 30,00~          0    349.     233.      465.  9.8 e-7
       9 Sample     0_cells x H~ 35,00~          0    320.     204.      437.  2.81e-6
      10 Sample     0_cells x H~ 5,000~          0    141.      24.7     257.  1.3 e-2
      # i 21 more rows
      # i 1 more variable: p.adj.signif <chr>

