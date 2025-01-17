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
                              Sample
      1 35,000_cells x HCMEC D3_line
      2 30,000_cells x HCMEC D3_line
      3 25,000_cells x HCMEC D3_line
      4 20,000_cells x HCMEC D3_line
      5 15,000_cells x HCMEC D3_line
      6 10,000_cells x HCMEC D3_line
      7  5,000_cells x HCMEC D3_line
      8      0_cells x HCMEC D3_line
                                                                                                                                                                                                                                         Label
      1    5,000_cells x HCMEC D3_line ***\n0_cells x HCMEC D3_line ***\n10,000_cells x HCMEC D3_line ***\n15,000_cells x HCMEC D3_line ***\n20,000_cells x HCMEC D3_line ***\n25,000_cells x HCMEC D3_line **\n30,000_cells x HCMEC D3_line  
      2        35,000_cells x HCMEC D3_line  \n5,000_cells x HCMEC D3_line ***\n0_cells x HCMEC D3_line ***\n10,000_cells x HCMEC D3_line ***\n15,000_cells x HCMEC D3_line **\n20,000_cells x HCMEC D3_line *\n25,000_cells x HCMEC D3_line  
      3         30,000_cells x HCMEC D3_line  \n35,000_cells x HCMEC D3_line **\n5,000_cells x HCMEC D3_line ***\n0_cells x HCMEC D3_line ***\n10,000_cells x HCMEC D3_line **\n15,000_cells x HCMEC D3_line .\n20,000_cells x HCMEC D3_line  
      4           25,000_cells x HCMEC D3_line  \n30,000_cells x HCMEC D3_line *\n35,000_cells x HCMEC D3_line ***\n5,000_cells x HCMEC D3_line *\n0_cells x HCMEC D3_line ***\n10,000_cells x HCMEC D3_line  \n15,000_cells x HCMEC D3_line  
      5           20,000_cells x HCMEC D3_line  \n25,000_cells x HCMEC D3_line .\n30,000_cells x HCMEC D3_line **\n35,000_cells x HCMEC D3_line ***\n5,000_cells x HCMEC D3_line  \n0_cells x HCMEC D3_line **\n10,000_cells x HCMEC D3_line  
      6          15,000_cells x HCMEC D3_line  \n20,000_cells x HCMEC D3_line  \n25,000_cells x HCMEC D3_line **\n30,000_cells x HCMEC D3_line ***\n35,000_cells x HCMEC D3_line ***\n5,000_cells x HCMEC D3_line  \n0_cells x HCMEC D3_line .
      7        0_cells x HCMEC D3_line  \n10,000_cells x HCMEC D3_line  \n15,000_cells x HCMEC D3_line  \n20,000_cells x HCMEC D3_line *\n25,000_cells x HCMEC D3_line ***\n30,000_cells x HCMEC D3_line ***\n35,000_cells x HCMEC D3_line ***
      8 10,000_cells x HCMEC D3_line .\n15,000_cells x HCMEC D3_line **\n20,000_cells x HCMEC D3_line ***\n25,000_cells x HCMEC D3_line ***\n30,000_cells x HCMEC D3_line ***\n35,000_cells x HCMEC D3_line ***\n5,000_cells x HCMEC D3_line  

---

    Code
      vascr_make_significance_table(growth.df, 50, "R", 4000, 0.95, format = "Tukey_data")
    Output
                                                                      diff
      10,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       108.88489
      15,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       157.89116
      20,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       202.24937
      25,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       268.18890
      30,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       344.07179
      35,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       424.47525
      5,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line         54.92496
      15,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line   49.00626
      20,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line   93.36447
      25,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line  159.30401
      30,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line  235.18690
      35,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line  315.59036
      5,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line   -53.95993
      20,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line   44.35821
      25,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line  110.29775
      30,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line  186.18063
      35,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line  266.58409
      5,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line  -102.96619
      25,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line   65.93954
      30,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line  141.82242
      35,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line  222.22588
      5,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line  -147.32440
      30,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line   75.88288
      35,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line  156.28634
      5,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line  -213.26394
      35,000_cells x HCMEC D3_line-30,000_cells x HCMEC D3_line   80.40346
      5,000_cells x HCMEC D3_line-30,000_cells x HCMEC D3_line  -289.14682
      5,000_cells x HCMEC D3_line-35,000_cells x HCMEC D3_line  -369.55029
                                                                        lwr
      10,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       -11.138852
      15,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line        37.867412
      20,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line        82.225621
      25,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       148.165160
      30,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       224.048044
      35,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       304.451505
      5,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line        -65.098781
      15,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line  -71.017481
      20,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line  -26.659272
      25,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line   39.280267
      30,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line  115.163151
      35,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line  195.566612
      5,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line  -173.983674
      20,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line  -75.665536
      25,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line   -9.725997
      30,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line   66.156887
      35,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line  146.560348
      5,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line  -222.989937
      25,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line  -54.084205
      30,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line   21.798679
      35,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line  102.202139
      5,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line  -267.348146
      30,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line  -44.140861
      35,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line   36.262600
      5,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line  -333.287686
      35,000_cells x HCMEC D3_line-30,000_cells x HCMEC D3_line  -39.620284
      5,000_cells x HCMEC D3_line-30,000_cells x HCMEC D3_line  -409.170570
      5,000_cells x HCMEC D3_line-35,000_cells x HCMEC D3_line  -489.574030
                                                                       upr
      10,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       228.90864
      15,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       277.91490
      20,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       322.27311
      25,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       388.21265
      30,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       464.09553
      35,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       544.49899
      5,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line        174.94871
      15,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line  169.03001
      20,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line  213.38822
      25,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line  279.32776
      30,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line  355.21064
      35,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line  435.61410
      5,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line    66.06382
      20,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line  164.38195
      25,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line  230.32149
      30,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line  306.20438
      35,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line  386.60784
      5,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line    17.05755
      25,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line  185.96328
      30,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line  261.84617
      35,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line  342.24963
      5,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line   -27.30066
      30,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line  195.90663
      35,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line  276.31009
      5,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line   -93.24020
      35,000_cells x HCMEC D3_line-30,000_cells x HCMEC D3_line  200.42720
      5,000_cells x HCMEC D3_line-30,000_cells x HCMEC D3_line  -169.12308
      5,000_cells x HCMEC D3_line-35,000_cells x HCMEC D3_line  -249.52654
                                                                       p.adj
      10,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      8.836009e-02
      15,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      6.775129e-03
      20,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      7.002647e-04
      25,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      3.396118e-05
      30,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      1.755401e-06
      35,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      1.254421e-07
      5,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       7.354339e-01
      15,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 8.245504e-01
      20,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 1.868868e-01
      25,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 6.289334e-03
      30,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 1.460653e-04
      35,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 5.028740e-06
      5,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line  7.508428e-01
      20,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line 8.829857e-01
      25,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line 8.229618e-02
      30,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line 1.564115e-03
      35,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line 3.636533e-05
      5,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line  1.184702e-01
      25,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line 5.492612e-01
      30,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line 1.586097e-02
      35,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line 2.670880e-04
      5,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line  1.184644e-02
      30,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line 3.902807e-01
      35,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line 7.373386e-03
      5,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line  4.095282e-04
      35,000_cells x HCMEC D3_line-30,000_cells x HCMEC D3_line 3.273222e-01
      5,000_cells x HCMEC D3_line-30,000_cells x HCMEC D3_line  1.422444e-05
      5,000_cells x HCMEC D3_line-35,000_cells x HCMEC D3_line  7.234402e-07
                                                                                           A
      10,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      10,000_cells x HCMEC D3_line
      15,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      15,000_cells x HCMEC D3_line
      20,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      20,000_cells x HCMEC D3_line
      25,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      25,000_cells x HCMEC D3_line
      30,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      30,000_cells x HCMEC D3_line
      35,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      35,000_cells x HCMEC D3_line
      5,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line        5,000_cells x HCMEC D3_line
      15,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 15,000_cells x HCMEC D3_line
      20,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 20,000_cells x HCMEC D3_line
      25,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 25,000_cells x HCMEC D3_line
      30,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 30,000_cells x HCMEC D3_line
      35,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 35,000_cells x HCMEC D3_line
      5,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line   5,000_cells x HCMEC D3_line
      20,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line 20,000_cells x HCMEC D3_line
      25,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line 25,000_cells x HCMEC D3_line
      30,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line 30,000_cells x HCMEC D3_line
      35,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line 35,000_cells x HCMEC D3_line
      5,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line   5,000_cells x HCMEC D3_line
      25,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line 25,000_cells x HCMEC D3_line
      30,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line 30,000_cells x HCMEC D3_line
      35,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line 35,000_cells x HCMEC D3_line
      5,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line   5,000_cells x HCMEC D3_line
      30,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line 30,000_cells x HCMEC D3_line
      35,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line 35,000_cells x HCMEC D3_line
      5,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line   5,000_cells x HCMEC D3_line
      35,000_cells x HCMEC D3_line-30,000_cells x HCMEC D3_line 35,000_cells x HCMEC D3_line
      5,000_cells x HCMEC D3_line-30,000_cells x HCMEC D3_line   5,000_cells x HCMEC D3_line
      5,000_cells x HCMEC D3_line-35,000_cells x HCMEC D3_line   5,000_cells x HCMEC D3_line
                                                                                           B
      10,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line           0_cells x HCMEC D3_line
      15,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line           0_cells x HCMEC D3_line
      20,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line           0_cells x HCMEC D3_line
      25,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line           0_cells x HCMEC D3_line
      30,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line           0_cells x HCMEC D3_line
      35,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line           0_cells x HCMEC D3_line
      5,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line            0_cells x HCMEC D3_line
      15,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 10,000_cells x HCMEC D3_line
      20,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 10,000_cells x HCMEC D3_line
      25,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 10,000_cells x HCMEC D3_line
      30,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 10,000_cells x HCMEC D3_line
      35,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 10,000_cells x HCMEC D3_line
      5,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line  10,000_cells x HCMEC D3_line
      20,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line 15,000_cells x HCMEC D3_line
      25,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line 15,000_cells x HCMEC D3_line
      30,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line 15,000_cells x HCMEC D3_line
      35,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line 15,000_cells x HCMEC D3_line
      5,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line  15,000_cells x HCMEC D3_line
      25,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line 20,000_cells x HCMEC D3_line
      30,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line 20,000_cells x HCMEC D3_line
      35,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line 20,000_cells x HCMEC D3_line
      5,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line  20,000_cells x HCMEC D3_line
      30,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line 25,000_cells x HCMEC D3_line
      35,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line 25,000_cells x HCMEC D3_line
      5,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line  25,000_cells x HCMEC D3_line
      35,000_cells x HCMEC D3_line-30,000_cells x HCMEC D3_line 30,000_cells x HCMEC D3_line
      5,000_cells x HCMEC D3_line-30,000_cells x HCMEC D3_line  30,000_cells x HCMEC D3_line
      5,000_cells x HCMEC D3_line-35,000_cells x HCMEC D3_line  35,000_cells x HCMEC D3_line
                                                                 Tukey.level
      10,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      8.836009e-02
      15,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      6.775129e-03
      20,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      7.002647e-04
      25,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      3.396118e-05
      30,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      1.755401e-06
      35,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      1.254421e-07
      5,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       7.354339e-01
      15,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 8.245504e-01
      20,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 1.868868e-01
      25,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 6.289334e-03
      30,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 1.460653e-04
      35,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 5.028740e-06
      5,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line  7.508428e-01
      20,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line 8.829857e-01
      25,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line 8.229618e-02
      30,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line 1.564115e-03
      35,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line 3.636533e-05
      5,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line  1.184702e-01
      25,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line 5.492612e-01
      30,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line 1.586097e-02
      35,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line 2.670880e-04
      5,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line  1.184644e-02
      30,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line 3.902807e-01
      35,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line 7.373386e-03
      5,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line  4.095282e-04
      35,000_cells x HCMEC D3_line-30,000_cells x HCMEC D3_line 3.273222e-01
      5,000_cells x HCMEC D3_line-30,000_cells x HCMEC D3_line  1.422444e-05
      5,000_cells x HCMEC D3_line-35,000_cells x HCMEC D3_line  7.234402e-07
                                                                Significance
      10,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line                 .
      15,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line                **
      20,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line               ***
      25,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line               ***
      30,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line               ***
      35,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line               ***
      5,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line                   
      15,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line             
      20,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line             
      25,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line           **
      30,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line          ***
      35,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line          ***
      5,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line              
      20,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line             
      25,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line            .
      30,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line           **
      35,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line          ***
      5,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line              
      25,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line             
      30,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line            *
      35,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line          ***
      5,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line             *
      30,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line             
      35,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line           **
      5,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line           ***
      35,000_cells x HCMEC D3_line-30,000_cells x HCMEC D3_line             
      5,000_cells x HCMEC D3_line-30,000_cells x HCMEC D3_line           ***
      5,000_cells x HCMEC D3_line-35,000_cells x HCMEC D3_line           ***

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
                                                                        diff
      10,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       318.8697078
      15,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       366.0356667
      20,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       365.4255756
      25,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       357.8468379
      30,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       349.0546710
      35,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       320.4320091
      5,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line        140.8348047
      15,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line   47.1659590
      20,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line   46.5558678
      25,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line   38.9771302
      30,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line   30.1849633
      35,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line    1.5623013
      5,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line  -178.0349030
      20,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line   -0.6100912
      25,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line   -8.1888288
      30,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line  -16.9809957
      35,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line  -45.6036577
      5,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line  -225.2008620
      25,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line   -7.5787377
      30,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line  -16.3709046
      35,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line  -44.9935665
      5,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line  -224.5907709
      30,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line   -8.7921669
      35,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line  -37.4148288
      5,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line  -217.0120332
      35,000_cells x HCMEC D3_line-30,000_cells x HCMEC D3_line  -28.6226619
      5,000_cells x HCMEC D3_line-30,000_cells x HCMEC D3_line  -208.2198663
      5,000_cells x HCMEC D3_line-35,000_cells x HCMEC D3_line  -179.5972044
                                                                       lwr        upr
      10,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       202.70847  435.03095
      15,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       249.87443  482.19691
      20,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       249.26433  481.58682
      25,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       241.68560  474.00808
      30,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       232.89343  465.21591
      35,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       204.27077  436.59325
      5,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line         24.67356  256.99605
      15,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line  -68.99528  163.32720
      20,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line  -69.60537  162.71711
      25,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line  -77.18411  155.13837
      30,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line  -85.97628  146.34620
      35,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line -114.59894  117.72354
      5,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line  -294.19614  -61.87366
      20,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line -116.77133  115.55115
      25,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line -124.35007  107.97241
      30,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line -133.14224   99.18024
      35,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line -161.76490   70.55758
      5,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line  -341.36210 -109.03962
      25,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line -123.73998  108.58250
      30,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line -132.53215   99.79034
      35,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line -161.15481   71.16767
      5,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line  -340.75201 -108.42953
      30,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line -124.95341  107.36907
      35,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line -153.57607   78.74641
      5,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line  -333.17327 -100.85079
      35,000_cells x HCMEC D3_line-30,000_cells x HCMEC D3_line -144.78390   87.53858
      5,000_cells x HCMEC D3_line-30,000_cells x HCMEC D3_line  -324.38111  -92.05863
      5,000_cells x HCMEC D3_line-35,000_cells x HCMEC D3_line  -295.75845  -63.43596
                                                                       p.adj
      10,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      2.985548e-06
      15,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      5.413543e-07
      20,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      5.528030e-07
      25,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      7.186768e-07
      30,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      9.800410e-07
      35,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      2.812867e-06
      5,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       1.303752e-02
      15,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 8.282857e-01
      20,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 8.368011e-01
      25,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 9.239222e-01
      30,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 9.791281e-01
      35,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 1.000000e+00
      5,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line  1.751519e-03
      20,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line 1.000000e+00
      25,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line 9.999951e-01
      30,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line 9.993464e-01
      35,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line 8.496814e-01
      5,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line  1.638600e-04
      25,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line 9.999971e-01
      30,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line 9.994841e-01
      35,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line 8.576615e-01
      5,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line  1.687008e-04
      30,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line 9.999920e-01
      35,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line 9.372571e-01
      5,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line  2.430383e-04
      35,000_cells x HCMEC D3_line-30,000_cells x HCMEC D3_line 9.844247e-01
      5,000_cells x HCMEC D3_line-30,000_cells x HCMEC D3_line  3.741608e-04
      5,000_cells x HCMEC D3_line-35,000_cells x HCMEC D3_line  1.613445e-03
                                                                                           A
      10,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      10,000_cells x HCMEC D3_line
      15,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      15,000_cells x HCMEC D3_line
      20,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      20,000_cells x HCMEC D3_line
      25,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      25,000_cells x HCMEC D3_line
      30,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      30,000_cells x HCMEC D3_line
      35,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      35,000_cells x HCMEC D3_line
      5,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line        5,000_cells x HCMEC D3_line
      15,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 15,000_cells x HCMEC D3_line
      20,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 20,000_cells x HCMEC D3_line
      25,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 25,000_cells x HCMEC D3_line
      30,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 30,000_cells x HCMEC D3_line
      35,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 35,000_cells x HCMEC D3_line
      5,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line   5,000_cells x HCMEC D3_line
      20,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line 20,000_cells x HCMEC D3_line
      25,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line 25,000_cells x HCMEC D3_line
      30,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line 30,000_cells x HCMEC D3_line
      35,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line 35,000_cells x HCMEC D3_line
      5,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line   5,000_cells x HCMEC D3_line
      25,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line 25,000_cells x HCMEC D3_line
      30,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line 30,000_cells x HCMEC D3_line
      35,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line 35,000_cells x HCMEC D3_line
      5,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line   5,000_cells x HCMEC D3_line
      30,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line 30,000_cells x HCMEC D3_line
      35,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line 35,000_cells x HCMEC D3_line
      5,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line   5,000_cells x HCMEC D3_line
      35,000_cells x HCMEC D3_line-30,000_cells x HCMEC D3_line 35,000_cells x HCMEC D3_line
      5,000_cells x HCMEC D3_line-30,000_cells x HCMEC D3_line   5,000_cells x HCMEC D3_line
      5,000_cells x HCMEC D3_line-35,000_cells x HCMEC D3_line   5,000_cells x HCMEC D3_line
                                                                                           B
      10,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line           0_cells x HCMEC D3_line
      15,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line           0_cells x HCMEC D3_line
      20,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line           0_cells x HCMEC D3_line
      25,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line           0_cells x HCMEC D3_line
      30,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line           0_cells x HCMEC D3_line
      35,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line           0_cells x HCMEC D3_line
      5,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line            0_cells x HCMEC D3_line
      15,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 10,000_cells x HCMEC D3_line
      20,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 10,000_cells x HCMEC D3_line
      25,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 10,000_cells x HCMEC D3_line
      30,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 10,000_cells x HCMEC D3_line
      35,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 10,000_cells x HCMEC D3_line
      5,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line  10,000_cells x HCMEC D3_line
      20,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line 15,000_cells x HCMEC D3_line
      25,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line 15,000_cells x HCMEC D3_line
      30,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line 15,000_cells x HCMEC D3_line
      35,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line 15,000_cells x HCMEC D3_line
      5,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line  15,000_cells x HCMEC D3_line
      25,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line 20,000_cells x HCMEC D3_line
      30,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line 20,000_cells x HCMEC D3_line
      35,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line 20,000_cells x HCMEC D3_line
      5,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line  20,000_cells x HCMEC D3_line
      30,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line 25,000_cells x HCMEC D3_line
      35,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line 25,000_cells x HCMEC D3_line
      5,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line  25,000_cells x HCMEC D3_line
      35,000_cells x HCMEC D3_line-30,000_cells x HCMEC D3_line 30,000_cells x HCMEC D3_line
      5,000_cells x HCMEC D3_line-30,000_cells x HCMEC D3_line  30,000_cells x HCMEC D3_line
      5,000_cells x HCMEC D3_line-35,000_cells x HCMEC D3_line  35,000_cells x HCMEC D3_line
                                                                 Tukey.level
      10,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      2.985548e-06
      15,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      5.413543e-07
      20,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      5.528030e-07
      25,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      7.186768e-07
      30,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      9.800410e-07
      35,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      2.812867e-06
      5,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       1.303752e-02
      15,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 8.282857e-01
      20,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 8.368011e-01
      25,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 9.239222e-01
      30,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 9.791281e-01
      35,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 1.000000e+00
      5,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line  1.751519e-03
      20,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line 1.000000e+00
      25,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line 9.999951e-01
      30,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line 9.993464e-01
      35,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line 8.496814e-01
      5,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line  1.638600e-04
      25,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line 9.999971e-01
      30,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line 9.994841e-01
      35,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line 8.576615e-01
      5,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line  1.687008e-04
      30,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line 9.999920e-01
      35,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line 9.372571e-01
      5,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line  2.430383e-04
      35,000_cells x HCMEC D3_line-30,000_cells x HCMEC D3_line 9.844247e-01
      5,000_cells x HCMEC D3_line-30,000_cells x HCMEC D3_line  3.741608e-04
      5,000_cells x HCMEC D3_line-35,000_cells x HCMEC D3_line  1.613445e-03
                                                                Significance
      10,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line               ***
      15,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line               ***
      20,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line               ***
      25,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line               ***
      30,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line               ***
      35,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line               ***
      5,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line                  *
      15,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line             
      20,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line             
      25,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line             
      30,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line             
      35,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line             
      5,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line            **
      20,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line             
      25,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line             
      30,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line             
      35,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line             
      5,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line           ***
      25,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line             
      30,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line             
      35,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line             
      5,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line           ***
      30,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line             
      35,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line             
      5,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line           ***
      35,000_cells x HCMEC D3_line-30,000_cells x HCMEC D3_line             
      5,000_cells x HCMEC D3_line-30,000_cells x HCMEC D3_line           ***
      5,000_cells x HCMEC D3_line-35,000_cells x HCMEC D3_line            **

---

    Code
      vascr_tukey(growth.df, "R", 4000, 100, raw = TRUE)
    Output
                                                                        diff
      10,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       318.8697078
      15,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       366.0356667
      20,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       365.4255756
      25,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       357.8468379
      30,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       349.0546710
      35,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       320.4320091
      5,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line        140.8348047
      15,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line   47.1659590
      20,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line   46.5558678
      25,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line   38.9771302
      30,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line   30.1849633
      35,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line    1.5623013
      5,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line  -178.0349030
      20,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line   -0.6100912
      25,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line   -8.1888288
      30,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line  -16.9809957
      35,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line  -45.6036577
      5,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line  -225.2008620
      25,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line   -7.5787377
      30,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line  -16.3709046
      35,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line  -44.9935665
      5,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line  -224.5907709
      30,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line   -8.7921669
      35,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line  -37.4148288
      5,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line  -217.0120332
      35,000_cells x HCMEC D3_line-30,000_cells x HCMEC D3_line  -28.6226619
      5,000_cells x HCMEC D3_line-30,000_cells x HCMEC D3_line  -208.2198663
      5,000_cells x HCMEC D3_line-35,000_cells x HCMEC D3_line  -179.5972044
                                                                       lwr        upr
      10,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       202.70847  435.03095
      15,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       249.87443  482.19691
      20,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       249.26433  481.58682
      25,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       241.68560  474.00808
      30,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       232.89343  465.21591
      35,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       204.27077  436.59325
      5,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line         24.67356  256.99605
      15,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line  -68.99528  163.32720
      20,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line  -69.60537  162.71711
      25,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line  -77.18411  155.13837
      30,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line  -85.97628  146.34620
      35,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line -114.59894  117.72354
      5,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line  -294.19614  -61.87366
      20,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line -116.77133  115.55115
      25,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line -124.35007  107.97241
      30,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line -133.14224   99.18024
      35,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line -161.76490   70.55758
      5,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line  -341.36210 -109.03962
      25,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line -123.73998  108.58250
      30,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line -132.53215   99.79034
      35,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line -161.15481   71.16767
      5,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line  -340.75201 -108.42953
      30,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line -124.95341  107.36907
      35,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line -153.57607   78.74641
      5,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line  -333.17327 -100.85079
      35,000_cells x HCMEC D3_line-30,000_cells x HCMEC D3_line -144.78390   87.53858
      5,000_cells x HCMEC D3_line-30,000_cells x HCMEC D3_line  -324.38111  -92.05863
      5,000_cells x HCMEC D3_line-35,000_cells x HCMEC D3_line  -295.75845  -63.43596
                                                                       p.adj
      10,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      2.985548e-06
      15,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      5.413543e-07
      20,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      5.528030e-07
      25,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      7.186768e-07
      30,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      9.800410e-07
      35,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      2.812867e-06
      5,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       1.303752e-02
      15,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 8.282857e-01
      20,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 8.368011e-01
      25,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 9.239222e-01
      30,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 9.791281e-01
      35,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 1.000000e+00
      5,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line  1.751519e-03
      20,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line 1.000000e+00
      25,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line 9.999951e-01
      30,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line 9.993464e-01
      35,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line 8.496814e-01
      5,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line  1.638600e-04
      25,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line 9.999971e-01
      30,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line 9.994841e-01
      35,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line 8.576615e-01
      5,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line  1.687008e-04
      30,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line 9.999920e-01
      35,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line 9.372571e-01
      5,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line  2.430383e-04
      35,000_cells x HCMEC D3_line-30,000_cells x HCMEC D3_line 9.844247e-01
      5,000_cells x HCMEC D3_line-30,000_cells x HCMEC D3_line  3.741608e-04
      5,000_cells x HCMEC D3_line-35,000_cells x HCMEC D3_line  1.613445e-03
                                                                                           A
      10,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      10,000_cells x HCMEC D3_line
      15,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      15,000_cells x HCMEC D3_line
      20,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      20,000_cells x HCMEC D3_line
      25,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      25,000_cells x HCMEC D3_line
      30,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      30,000_cells x HCMEC D3_line
      35,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      35,000_cells x HCMEC D3_line
      5,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line        5,000_cells x HCMEC D3_line
      15,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 15,000_cells x HCMEC D3_line
      20,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 20,000_cells x HCMEC D3_line
      25,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 25,000_cells x HCMEC D3_line
      30,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 30,000_cells x HCMEC D3_line
      35,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 35,000_cells x HCMEC D3_line
      5,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line   5,000_cells x HCMEC D3_line
      20,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line 20,000_cells x HCMEC D3_line
      25,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line 25,000_cells x HCMEC D3_line
      30,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line 30,000_cells x HCMEC D3_line
      35,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line 35,000_cells x HCMEC D3_line
      5,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line   5,000_cells x HCMEC D3_line
      25,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line 25,000_cells x HCMEC D3_line
      30,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line 30,000_cells x HCMEC D3_line
      35,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line 35,000_cells x HCMEC D3_line
      5,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line   5,000_cells x HCMEC D3_line
      30,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line 30,000_cells x HCMEC D3_line
      35,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line 35,000_cells x HCMEC D3_line
      5,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line   5,000_cells x HCMEC D3_line
      35,000_cells x HCMEC D3_line-30,000_cells x HCMEC D3_line 35,000_cells x HCMEC D3_line
      5,000_cells x HCMEC D3_line-30,000_cells x HCMEC D3_line   5,000_cells x HCMEC D3_line
      5,000_cells x HCMEC D3_line-35,000_cells x HCMEC D3_line   5,000_cells x HCMEC D3_line
                                                                                           B
      10,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line           0_cells x HCMEC D3_line
      15,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line           0_cells x HCMEC D3_line
      20,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line           0_cells x HCMEC D3_line
      25,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line           0_cells x HCMEC D3_line
      30,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line           0_cells x HCMEC D3_line
      35,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line           0_cells x HCMEC D3_line
      5,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line            0_cells x HCMEC D3_line
      15,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 10,000_cells x HCMEC D3_line
      20,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 10,000_cells x HCMEC D3_line
      25,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 10,000_cells x HCMEC D3_line
      30,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 10,000_cells x HCMEC D3_line
      35,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 10,000_cells x HCMEC D3_line
      5,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line  10,000_cells x HCMEC D3_line
      20,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line 15,000_cells x HCMEC D3_line
      25,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line 15,000_cells x HCMEC D3_line
      30,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line 15,000_cells x HCMEC D3_line
      35,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line 15,000_cells x HCMEC D3_line
      5,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line  15,000_cells x HCMEC D3_line
      25,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line 20,000_cells x HCMEC D3_line
      30,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line 20,000_cells x HCMEC D3_line
      35,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line 20,000_cells x HCMEC D3_line
      5,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line  20,000_cells x HCMEC D3_line
      30,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line 25,000_cells x HCMEC D3_line
      35,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line 25,000_cells x HCMEC D3_line
      5,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line  25,000_cells x HCMEC D3_line
      35,000_cells x HCMEC D3_line-30,000_cells x HCMEC D3_line 30,000_cells x HCMEC D3_line
      5,000_cells x HCMEC D3_line-30,000_cells x HCMEC D3_line  30,000_cells x HCMEC D3_line
      5,000_cells x HCMEC D3_line-35,000_cells x HCMEC D3_line  35,000_cells x HCMEC D3_line
                                                                 Tukey.level
      10,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      2.985548e-06
      15,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      5.413543e-07
      20,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      5.528030e-07
      25,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      7.186768e-07
      30,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      9.800410e-07
      35,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      2.812867e-06
      5,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       1.303752e-02
      15,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 8.282857e-01
      20,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 8.368011e-01
      25,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 9.239222e-01
      30,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 9.791281e-01
      35,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 1.000000e+00
      5,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line  1.751519e-03
      20,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line 1.000000e+00
      25,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line 9.999951e-01
      30,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line 9.993464e-01
      35,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line 8.496814e-01
      5,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line  1.638600e-04
      25,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line 9.999971e-01
      30,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line 9.994841e-01
      35,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line 8.576615e-01
      5,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line  1.687008e-04
      30,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line 9.999920e-01
      35,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line 9.372571e-01
      5,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line  2.430383e-04
      35,000_cells x HCMEC D3_line-30,000_cells x HCMEC D3_line 9.844247e-01
      5,000_cells x HCMEC D3_line-30,000_cells x HCMEC D3_line  3.741608e-04
      5,000_cells x HCMEC D3_line-35,000_cells x HCMEC D3_line  1.613445e-03
                                                                Significance
      10,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line               ***
      15,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line               ***
      20,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line               ***
      25,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line               ***
      30,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line               ***
      35,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line               ***
      5,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line                  *
      15,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line             
      20,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line             
      25,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line             
      30,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line             
      35,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line             
      5,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line            **
      20,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line             
      25,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line             
      30,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line             
      35,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line             
      5,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line           ***
      25,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line             
      30,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line             
      35,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line             
      5,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line           ***
      30,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line             
      35,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line             
      5,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line           ***
      35,000_cells x HCMEC D3_line-30,000_cells x HCMEC D3_line             
      5,000_cells x HCMEC D3_line-30,000_cells x HCMEC D3_line           ***
      5,000_cells x HCMEC D3_line-35,000_cells x HCMEC D3_line            **

