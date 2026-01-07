# Summarise a vascr data set down to a particular level

Summarise a vascr data set down to a particular level

## Usage

``` r
vascr_summarise(data.df, level = "wells")
```

## Arguments

- data.df:

  Data set to summarize

- level:

  Level to summarise to, either "summary", "experiment" or "wells"

## Value

The summarized data set

## Examples

``` r
rbgrowth.df = vascr_subset(growth.df, unit = "Rb")

vascr_summarise(rbgrowth.df, level = "summary")
#> # A tibble: 312 × 14
#>     Time Unit  Frequency Sample      Instrument      sd totaln     n   min   max
#>    <dbl> <fct>     <dbl> <chr>       <chr>        <dbl>  <int> <int> <dbl> <dbl>
#>  1     5 Rb            0 0_cells + … ECIS       NA           3     1     0  0   
#>  2     5 Rb            0 10,000_cel… ECIS        0           9     3     0  0   
#>  3     5 Rb            0 15,000_cel… ECIS        0           9     3     0  0   
#>  4     5 Rb            0 20,000_cel… ECIS        0           9     3     0  0   
#>  5     5 Rb            0 25,000_cel… ECIS        0           9     3     0  0   
#>  6     5 Rb            0 30,000_cel… ECIS        0           9     3     0  0   
#>  7     5 Rb            0 35,000_cel… ECIS        0           9     3     0  0   
#>  8     5 Rb            0 5,000_cell… ECIS        0.0337      9     3     0  0.06
#>  9    10 Rb            0 0_cells + … ECIS       NA           3     1     0  0   
#> 10    10 Rb            0 10,000_cel… ECIS        0           9     3     0  0   
#> # ℹ 302 more rows
#> # ℹ 4 more variables: Well <chr>, Value <dbl>, Experiment <chr>, sem <dbl>
vascr_summarise(rbgrowth.df, level = "experiment")
#> ! [experiment] corrected to [experiments]. Please check the argeuments for your functions are correctly typed.
#> # A tibble: 858 × 15
#>     Time Unit  Frequency Sample    Experiment Instrument SampleID Excluded    sd
#>    <dbl> <fct>     <dbl> <chr>     <fct>      <chr>         <int> <chr>    <dbl>
#>  1     5 Rb            0 0_cells … 3 : Exper… ECIS              8 no           0
#>  2     5 Rb            0 10,000_c… 1 : Exper… ECIS              6 no           0
#>  3     5 Rb            0 10,000_c… 2 : Exper… ECIS              6 no           0
#>  4     5 Rb            0 10,000_c… 3 : Exper… ECIS              6 no           0
#>  5     5 Rb            0 15,000_c… 1 : Exper… ECIS              5 no           0
#>  6     5 Rb            0 15,000_c… 2 : Exper… ECIS              5 no           0
#>  7     5 Rb            0 15,000_c… 3 : Exper… ECIS              5 no           0
#>  8     5 Rb            0 20,000_c… 1 : Exper… ECIS              4 no           0
#>  9     5 Rb            0 20,000_c… 2 : Exper… ECIS              4 no           0
#> 10     5 Rb            0 20,000_c… 3 : Exper… ECIS              4 no           0
#> # ℹ 848 more rows
#> # ℹ 6 more variables: n <int>, min <dbl>, max <dbl>, Well <chr>, Value <dbl>,
#> #   sem <dbl>
vascr_summarise(rbgrowth.df, level = "wells")
#> # A tibble: 2,574 × 12
#>     Time Unit  Well  Value Sample    Frequency Experiment cells line  Instrument
#>    <dbl> <fct> <chr> <dbl> <chr>         <dbl> <fct>      <chr> <chr> <chr>     
#>  1     5 Rb    A01       0 35,000_c…         0 1 : Exper… 35000 HCME… ECIS      
#>  2     5 Rb    A02       0 35,000_c…         0 1 : Exper… 35000 HCME… ECIS      
#>  3     5 Rb    A03       0 35,000_c…         0 1 : Exper… 35000 HCME… ECIS      
#>  4     5 Rb    B01       0 30,000_c…         0 1 : Exper… 30000 HCME… ECIS      
#>  5     5 Rb    B02       0 30,000_c…         0 1 : Exper… 30000 HCME… ECIS      
#>  6     5 Rb    B03       0 30,000_c…         0 1 : Exper… 30000 HCME… ECIS      
#>  7     5 Rb    C01       0 25,000_c…         0 1 : Exper… 25000 HCME… ECIS      
#>  8     5 Rb    C02       0 25,000_c…         0 1 : Exper… 25000 HCME… ECIS      
#>  9     5 Rb    C03       0 25,000_c…         0 1 : Exper… 25000 HCME… ECIS      
#> 10     5 Rb    D01       0 20,000_c…         0 1 : Exper… 20000 HCME… ECIS      
#> # ℹ 2,564 more rows
#> # ℹ 2 more variables: SampleID <int>, Excluded <chr>
```
