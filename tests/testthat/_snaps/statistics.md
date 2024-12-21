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
      1    5,000_cells x HCMEC D3_line ***\n0_cells x HCMEC D3_line ***\n10,000_cells x HCMEC D3_line ***\n15,000_cells x HCMEC D3_line ***\n20,000_cells x HCMEC D3_line ***\n25,000_cells x HCMEC D3_line ***\n30,000_cells x HCMEC D3_line ***
      2     35,000_cells x HCMEC D3_line ***\n5,000_cells x HCMEC D3_line ***\n0_cells x HCMEC D3_line ***\n10,000_cells x HCMEC D3_line ***\n15,000_cells x HCMEC D3_line ***\n20,000_cells x HCMEC D3_line ***\n25,000_cells x HCMEC D3_line **
      3      30,000_cells x HCMEC D3_line **\n35,000_cells x HCMEC D3_line ***\n5,000_cells x HCMEC D3_line ***\n0_cells x HCMEC D3_line ***\n10,000_cells x HCMEC D3_line ***\n15,000_cells x HCMEC D3_line ***\n20,000_cells x HCMEC D3_line **
      4       25,000_cells x HCMEC D3_line **\n30,000_cells x HCMEC D3_line ***\n35,000_cells x HCMEC D3_line ***\n5,000_cells x HCMEC D3_line ***\n0_cells x HCMEC D3_line ***\n10,000_cells x HCMEC D3_line ***\n15,000_cells x HCMEC D3_line  
      5        20,000_cells x HCMEC D3_line  \n25,000_cells x HCMEC D3_line ***\n30,000_cells x HCMEC D3_line ***\n35,000_cells x HCMEC D3_line ***\n5,000_cells x HCMEC D3_line ***\n0_cells x HCMEC D3_line ***\n10,000_cells x HCMEC D3_line  
      6        15,000_cells x HCMEC D3_line  \n20,000_cells x HCMEC D3_line ***\n25,000_cells x HCMEC D3_line ***\n30,000_cells x HCMEC D3_line ***\n35,000_cells x HCMEC D3_line ***\n5,000_cells x HCMEC D3_line .\n0_cells x HCMEC D3_line ***
      7       0_cells x HCMEC D3_line .\n10,000_cells x HCMEC D3_line .\n15,000_cells x HCMEC D3_line ***\n20,000_cells x HCMEC D3_line ***\n25,000_cells x HCMEC D3_line ***\n30,000_cells x HCMEC D3_line ***\n35,000_cells x HCMEC D3_line ***
      8 10,000_cells x HCMEC D3_line ***\n15,000_cells x HCMEC D3_line ***\n20,000_cells x HCMEC D3_line ***\n25,000_cells x HCMEC D3_line ***\n30,000_cells x HCMEC D3_line ***\n35,000_cells x HCMEC D3_line ***\n5,000_cells x HCMEC D3_line .

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
      10,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line        53.3333992
      15,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       102.3396630
      20,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       146.6978715
      25,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       212.6374111
      30,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       288.5202951
      35,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       368.9237554
      5,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line         -0.6265298
      15,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line   -6.5452301
      20,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line   37.8129784
      25,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line  103.7525180
      30,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line  179.6354021
      35,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line  260.0388623
      5,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line  -109.5114229
      20,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line  -11.1932854
      25,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line   54.7462542
      30,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line  130.6291382
      35,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line  211.0325985
      5,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line  -158.5176867
      25,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line   10.3880457
      30,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line   86.2709297
      35,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line  166.6743900
      5,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line  -202.8758952
      30,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line   20.3313901
      35,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line  100.7348504
      5,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line  -268.8154348
      35,000_cells x HCMEC D3_line-30,000_cells x HCMEC D3_line   24.8519663
      5,000_cells x HCMEC D3_line-30,000_cells x HCMEC D3_line  -344.6983189
      5,000_cells x HCMEC D3_line-35,000_cells x HCMEC D3_line  -425.1017791
                                                                        upr
      10,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       164.436387
      15,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       213.442651
      20,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       257.800859
      25,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       323.740399
      30,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       399.623283
      35,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       480.026743
      5,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line        110.476458
      15,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line  104.557758
      20,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line  148.915966
      25,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line  214.855506
      30,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line  290.738390
      35,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line  371.141850
      5,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line     1.591565
      20,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line   99.909702
      25,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line  165.849242
      30,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line  241.732126
      35,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line  322.135586
      5,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line   -47.414699
      25,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line  121.491034
      30,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line  197.373918
      35,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line  277.777378
      5,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line   -91.772907
      30,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line  131.434378
      35,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line  211.837838
      5,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line  -157.712447
      35,000_cells x HCMEC D3_line-30,000_cells x HCMEC D3_line  135.954954
      5,000_cells x HCMEC D3_line-30,000_cells x HCMEC D3_line  -233.595331
      5,000_cells x HCMEC D3_line-35,000_cells x HCMEC D3_line  -313.998791
                                                                       p.adj
      10,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      1.696479e-06
      15,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      4.789591e-11
      20,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      1.893752e-11
      25,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      1.890310e-11
      30,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      1.890288e-11
      35,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      1.890288e-11
      5,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       5.477456e-02
      15,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 1.224879e-01
      20,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 4.784795e-05
      25,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 4.008138e-11
      30,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 1.890510e-11
      35,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 1.890288e-11
      5,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line  6.290033e-02
      20,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line 2.128629e-01
      25,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line 1.243215e-06
      30,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line 1.901590e-11
      35,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line 1.890310e-11
      5,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line  6.172257e-06
      25,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line 9.543193e-03
      30,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line 1.082657e-09
      35,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line 1.891109e-11
      5,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line  3.273594e-10
      30,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line 1.585265e-03
      35,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line 6.035439e-11
      5,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line  1.891975e-11
      35,000_cells x HCMEC D3_line-30,000_cells x HCMEC D3_line 6.646683e-04
      5,000_cells x HCMEC D3_line-30,000_cells x HCMEC D3_line  1.890288e-11
      5,000_cells x HCMEC D3_line-35,000_cells x HCMEC D3_line  1.890288e-11
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
      10,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      1.696479e-06
      15,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      4.789591e-11
      20,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      1.893752e-11
      25,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      1.890310e-11
      30,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      1.890288e-11
      35,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      1.890288e-11
      5,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       5.477456e-02
      15,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 1.224879e-01
      20,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 4.784795e-05
      25,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 4.008138e-11
      30,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 1.890510e-11
      35,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 1.890288e-11
      5,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line  6.290033e-02
      20,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line 2.128629e-01
      25,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line 1.243215e-06
      30,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line 1.901590e-11
      35,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line 1.890310e-11
      5,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line  6.172257e-06
      25,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line 9.543193e-03
      30,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line 1.082657e-09
      35,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line 1.891109e-11
      5,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line  3.273594e-10
      30,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line 1.585265e-03
      35,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line 6.035439e-11
      5,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line  1.891975e-11
      35,000_cells x HCMEC D3_line-30,000_cells x HCMEC D3_line 6.646683e-04
      5,000_cells x HCMEC D3_line-30,000_cells x HCMEC D3_line  1.890288e-11
      5,000_cells x HCMEC D3_line-35,000_cells x HCMEC D3_line  1.890288e-11
                                                                Significance
      10,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line               ***
      15,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line               ***
      20,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line               ***
      25,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line               ***
      30,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line               ***
      35,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line               ***
      5,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line                  .
      15,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line             
      20,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line          ***
      25,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line          ***
      30,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line          ***
      35,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line          ***
      5,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line             .
      20,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line             
      25,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line          ***
      30,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line          ***
      35,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line          ***
      5,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line           ***
      25,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line           **
      30,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line          ***
      35,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line          ***
      5,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line           ***
      30,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line           **
      35,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line          ***
      5,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line           ***
      35,000_cells x HCMEC D3_line-30,000_cells x HCMEC D3_line          ***
      5,000_cells x HCMEC D3_line-30,000_cells x HCMEC D3_line           ***
      5,000_cells x HCMEC D3_line-35,000_cells x HCMEC D3_line           ***

# Residuals

    Code
      vascr_residuals(growth.df, "R", "4000", 100)
    Output
                 1            2            3            4            5            6 
      -24.28920848 -14.98986852 -24.84298887  -1.01918262  10.92881633   1.62439727 
                 7            8            9           10           11           12 
       21.45358319  18.78399498  12.27466394  29.11442345  38.01546145  20.96191202 
                13           14           15           16           17           18 
       42.60552176  45.67947881  35.46910852  77.16510646   8.13640923  45.25816683 
                19           20           21           22           23           24 
      -51.14251817 -45.50363567 -31.90356561 -71.90944544 -70.17949187 -71.69113900 
                25           26           27           28           29           30 
        3.98176855  13.35453186 -21.41921017 -15.68346390  11.79483172  -8.96012763 
                31           32           33           34           35           36 
      -16.38252332 -13.79272796 -19.57427370 -39.62844893 -28.06167637 -25.63329352 
                37           38           39           40           41           42 
       -6.40454029  -8.48846054 -20.58480210  12.86188362 -14.02529940   1.77935190 
                43           44           45           46           47           48 
       50.40502468  52.96572369  46.02890766  13.92699448  16.06960885  15.47022080 
                49           50           51           52           53           54 
       15.99361692  31.86053545  20.35082326   2.15114862   0.05887274  -0.89529254 
                55           56           57           58           59           60 
        2.36728224   0.86165452  -5.99165390   6.98643246   3.21766196  -4.97247254 
                61           62           63           64           65           66 
      -55.18427614 -34.87932476   1.78729473  -2.72068786 -40.10214644 -88.35278434 
                67           68           69           70           71           72 
       28.31877980 -18.97726170 -30.19145468  56.84412793  57.72431779  53.74480647 

# Shapiro Test

    Code
      vascr_shapiro(growth.df, "R", 4000, 100)
    Output
      
      	Shapiro-Wilk normality test
      
      data:  aov_residuals
      W = 0.98678, p-value = 0.6552
      

# Levene Test

    Code
      vascr_levene(growth.df, "R", 4000, 100)
    Output
      Levene's Test for Homogeneity of Variance (center = median)
            Df F value  Pr(>F)  
      group 23  1.5898 0.08762 .
            48                  
      ---
      Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

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
                                                                        lwr
      10,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       265.594696
      15,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       312.760655
      20,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       312.150564
      25,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       304.571826
      30,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       295.779659
      35,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       267.156997
      5,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line         87.559793
      15,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line   -6.109053
      20,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line   -6.719144
      25,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line  -14.297882
      30,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line  -23.090048
      35,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line  -51.712710
      5,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line  -231.309915
      20,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line  -53.885103
      25,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line  -61.463841
      30,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line  -70.256007
      35,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line  -98.878669
      5,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line  -278.475874
      25,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line  -60.853749
      30,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line  -69.645916
      35,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line  -98.268578
      5,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line  -277.865783
      30,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line  -62.067179
      35,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line  -90.689841
      5,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line  -270.287045
      35,000_cells x HCMEC D3_line-30,000_cells x HCMEC D3_line  -81.897674
      5,000_cells x HCMEC D3_line-30,000_cells x HCMEC D3_line  -261.494878
      5,000_cells x HCMEC D3_line-35,000_cells x HCMEC D3_line  -232.872216
                                                                        upr
      10,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       372.144719
      15,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       419.310678
      20,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       418.700587
      25,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       411.121850
      30,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       402.329683
      35,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       373.707021
      5,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line        194.109816
      15,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line  100.440971
      20,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line   99.830880
      25,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line   92.252142
      30,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line   83.459975
      35,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line   54.837313
      5,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line  -124.759891
      20,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line   52.664921
      25,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line   45.086183
      30,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line   36.294016
      35,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line    7.671354
      5,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line  -171.925850
      25,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line   45.696274
      30,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line   36.904107
      35,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line    8.281445
      5,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line  -171.315759
      30,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line   44.482845
      35,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line   15.860183
      5,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line  -163.737022
      35,000_cells x HCMEC D3_line-30,000_cells x HCMEC D3_line   24.652350
      5,000_cells x HCMEC D3_line-30,000_cells x HCMEC D3_line  -154.944855
      5,000_cells x HCMEC D3_line-35,000_cells x HCMEC D3_line  -126.322193
                                                                       p.adj
      10,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      1.890288e-11
      15,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      1.890288e-11
      20,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      1.890288e-11
      25,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      1.890288e-11
      30,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      1.890288e-11
      35,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      1.890288e-11
      5,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       3.618496e-10
      15,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 1.197922e-01
      20,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 1.298156e-01
      25,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 3.129593e-01
      30,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 6.373888e-01
      35,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 1.000000e+00
      5,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line  1.902545e-11
      20,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line 1.000000e+00
      25,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line 9.997034e-01
      30,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line 9.727893e-01
      35,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line 1.467682e-01
      5,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line  1.890488e-11
      25,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line 9.998229e-01
      30,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line 9.778112e-01
      35,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line 1.584985e-01
      5,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line  1.890554e-11
      30,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line 9.995257e-01
      35,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line 3.643463e-01
      5,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line  1.890932e-11
      35,000_cells x HCMEC D3_line-30,000_cells x HCMEC D3_line 6.964884e-01
      5,000_cells x HCMEC D3_line-30,000_cells x HCMEC D3_line  1.891554e-11
      5,000_cells x HCMEC D3_line-35,000_cells x HCMEC D3_line  1.900213e-11
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
      10,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      1.890288e-11
      15,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      1.890288e-11
      20,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      1.890288e-11
      25,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      1.890288e-11
      30,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      1.890288e-11
      35,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      1.890288e-11
      5,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       3.618496e-10
      15,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 1.197922e-01
      20,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 1.298156e-01
      25,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 3.129593e-01
      30,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 6.373888e-01
      35,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 1.000000e+00
      5,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line  1.902545e-11
      20,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line 1.000000e+00
      25,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line 9.997034e-01
      30,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line 9.727893e-01
      35,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line 1.467682e-01
      5,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line  1.890488e-11
      25,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line 9.998229e-01
      30,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line 9.778112e-01
      35,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line 1.584985e-01
      5,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line  1.890554e-11
      30,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line 9.995257e-01
      35,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line 3.643463e-01
      5,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line  1.890932e-11
      35,000_cells x HCMEC D3_line-30,000_cells x HCMEC D3_line 6.964884e-01
      5,000_cells x HCMEC D3_line-30,000_cells x HCMEC D3_line  1.891554e-11
      5,000_cells x HCMEC D3_line-35,000_cells x HCMEC D3_line  1.900213e-11
                                                                Significance
      10,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line               ***
      15,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line               ***
      20,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line               ***
      25,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line               ***
      30,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line               ***
      35,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line               ***
      5,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line                ***
      15,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line             
      20,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line             
      25,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line             
      30,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line             
      35,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line             
      5,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line           ***
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
      5,000_cells x HCMEC D3_line-35,000_cells x HCMEC D3_line           ***

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
                                                                        lwr
      10,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       265.594696
      15,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       312.760655
      20,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       312.150564
      25,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       304.571826
      30,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       295.779659
      35,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       267.156997
      5,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line         87.559793
      15,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line   -6.109053
      20,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line   -6.719144
      25,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line  -14.297882
      30,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line  -23.090048
      35,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line  -51.712710
      5,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line  -231.309915
      20,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line  -53.885103
      25,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line  -61.463841
      30,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line  -70.256007
      35,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line  -98.878669
      5,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line  -278.475874
      25,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line  -60.853749
      30,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line  -69.645916
      35,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line  -98.268578
      5,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line  -277.865783
      30,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line  -62.067179
      35,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line  -90.689841
      5,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line  -270.287045
      35,000_cells x HCMEC D3_line-30,000_cells x HCMEC D3_line  -81.897674
      5,000_cells x HCMEC D3_line-30,000_cells x HCMEC D3_line  -261.494878
      5,000_cells x HCMEC D3_line-35,000_cells x HCMEC D3_line  -232.872216
                                                                        upr
      10,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       372.144719
      15,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       419.310678
      20,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       418.700587
      25,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       411.121850
      30,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       402.329683
      35,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       373.707021
      5,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line        194.109816
      15,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line  100.440971
      20,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line   99.830880
      25,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line   92.252142
      30,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line   83.459975
      35,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line   54.837313
      5,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line  -124.759891
      20,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line   52.664921
      25,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line   45.086183
      30,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line   36.294016
      35,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line    7.671354
      5,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line  -171.925850
      25,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line   45.696274
      30,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line   36.904107
      35,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line    8.281445
      5,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line  -171.315759
      30,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line   44.482845
      35,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line   15.860183
      5,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line  -163.737022
      35,000_cells x HCMEC D3_line-30,000_cells x HCMEC D3_line   24.652350
      5,000_cells x HCMEC D3_line-30,000_cells x HCMEC D3_line  -154.944855
      5,000_cells x HCMEC D3_line-35,000_cells x HCMEC D3_line  -126.322193
                                                                       p.adj
      10,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      1.890288e-11
      15,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      1.890288e-11
      20,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      1.890288e-11
      25,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      1.890288e-11
      30,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      1.890288e-11
      35,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      1.890288e-11
      5,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       3.618496e-10
      15,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 1.197922e-01
      20,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 1.298156e-01
      25,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 3.129593e-01
      30,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 6.373888e-01
      35,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 1.000000e+00
      5,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line  1.902545e-11
      20,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line 1.000000e+00
      25,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line 9.997034e-01
      30,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line 9.727893e-01
      35,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line 1.467682e-01
      5,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line  1.890488e-11
      25,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line 9.998229e-01
      30,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line 9.778112e-01
      35,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line 1.584985e-01
      5,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line  1.890554e-11
      30,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line 9.995257e-01
      35,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line 3.643463e-01
      5,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line  1.890932e-11
      35,000_cells x HCMEC D3_line-30,000_cells x HCMEC D3_line 6.964884e-01
      5,000_cells x HCMEC D3_line-30,000_cells x HCMEC D3_line  1.891554e-11
      5,000_cells x HCMEC D3_line-35,000_cells x HCMEC D3_line  1.900213e-11
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
      10,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      1.890288e-11
      15,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      1.890288e-11
      20,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      1.890288e-11
      25,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      1.890288e-11
      30,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      1.890288e-11
      35,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line      1.890288e-11
      5,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line       3.618496e-10
      15,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 1.197922e-01
      20,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 1.298156e-01
      25,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 3.129593e-01
      30,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 6.373888e-01
      35,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line 1.000000e+00
      5,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line  1.902545e-11
      20,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line 1.000000e+00
      25,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line 9.997034e-01
      30,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line 9.727893e-01
      35,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line 1.467682e-01
      5,000_cells x HCMEC D3_line-15,000_cells x HCMEC D3_line  1.890488e-11
      25,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line 9.998229e-01
      30,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line 9.778112e-01
      35,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line 1.584985e-01
      5,000_cells x HCMEC D3_line-20,000_cells x HCMEC D3_line  1.890554e-11
      30,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line 9.995257e-01
      35,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line 3.643463e-01
      5,000_cells x HCMEC D3_line-25,000_cells x HCMEC D3_line  1.890932e-11
      35,000_cells x HCMEC D3_line-30,000_cells x HCMEC D3_line 6.964884e-01
      5,000_cells x HCMEC D3_line-30,000_cells x HCMEC D3_line  1.891554e-11
      5,000_cells x HCMEC D3_line-35,000_cells x HCMEC D3_line  1.900213e-11
                                                                Significance
      10,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line               ***
      15,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line               ***
      20,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line               ***
      25,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line               ***
      30,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line               ***
      35,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line               ***
      5,000_cells x HCMEC D3_line-0_cells x HCMEC D3_line                ***
      15,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line             
      20,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line             
      25,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line             
      30,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line             
      35,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line             
      5,000_cells x HCMEC D3_line-10,000_cells x HCMEC D3_line           ***
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
      5,000_cells x HCMEC D3_line-35,000_cells x HCMEC D3_line           ***

