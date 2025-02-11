# resample stretching works

    Code
      vascr_summarise_cc_stretch_shift_stats(data.df, 8)
    Message
      
      Attaching package: 'purrr'
      
      The following object is masked from 'package:testthat':
      
          is_null
      
    Output
      # A tibble: 24 x 12
         name       title     p  mean      sd nsample ncontrol Sample.x Sample.y refs 
         <chr>      <chr> <dbl> <dbl>   <dbl>   <int>    <int> <chr>    <chr>    <chr>
       1 cc         35,0~ 1     0.965 0.0250        3        6 35,000_~ 35,000_~ 0.98~
       2 shift_cc   35,0~ 1     0.965 0.0250        3        6 35,000_~ 35,000_~ 0.98~
       3 stretch_cc 35,0~ 1     0.997 0.00129       3        6 35,000_~ 35,000_~ 0.99~
       4 stretch_s~ 35,0~ 1     0.997 0.00129       3        6 35,000_~ 35,000_~ 0.99~
       5 cc         25,0~ 0.585 0.984 0.00908       3        6 25,000_~ 35,000_~ 0.99~
       6 shift_cc   25,0~ 0.585 0.984 0.00908       3        6 25,000_~ 35,000_~ 0.99~
       7 stretch_cc 25,0~ 0.701 0.997 0.00203       3        6 25,000_~ 35,000_~ 0.99~
       8 stretch_s~ 25,0~ 0.701 0.997 0.00203       3        6 25,000_~ 35,000_~ 0.99~
       9 cc         25,0~ 1     0.991 0.00473       3        6 25,000_~ 25,000_~ 0.99~
      10 shift_cc   25,0~ 1     0.991 0.00473       3        6 25,000_~ 25,000_~ 0.99~
      # i 14 more rows
      # i 2 more variables: padj <dbl>, stars <noquote>

