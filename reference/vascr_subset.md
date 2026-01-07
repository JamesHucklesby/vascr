# Subset a vascr data set based on a number of factors

Subset a vascr data set based on a number of factors

## Usage

``` r
vascr_subset(
  data.df,
  time = NULL,
  unit = NULL,
  well = NULL,
  frequency = NULL,
  experiment = NULL,
  instrument = NULL,
  sampleid = NULL,
  sample = NULL,
  subsample = NULL,
  remove_na_value = TRUE,
  remove_excluded = TRUE
)
```

## Arguments

- data.df:

  vascr data set to subset

- time:

  Specified times. Individual values in a list will be subset out. If
  vectors are present in the list, values between the two most extreme
  values will be returned.

- unit:

  Units to subset. These are checked for integrity against possible
  units and the dataset itself

- well:

  Wells to select

- frequency:

  Frequencies to include in the data set.

- experiment:

  Experiments to include in the data set. Can be addressed either by
  name, or by the numerical order that they were loaded into
  vascr_combine in

- instrument:

  Which instruments to include values from

- sampleid:

  List of ID's to be used. Sample names will be re-ordered accordingly
  for display.

- sample:

  Sample to subset

- subsample:

  Frequency values should be sub-sampled to

- remove_na_value:

  Should NA values be removed (default true)

- remove_excluded:

  Should excluded values be removed (default true)

## Value

The subset dataset, based on the values selected

## Examples

``` r
vascr_subset(growth.df)
#> # A tibble: 139,230 × 12
#>     Time Unit  Well  Value Sample    Frequency Experiment cells line  Instrument
#>    <dbl> <chr> <chr> <dbl> <chr>         <dbl> <fct>      <chr> <chr> <chr>     
#>  1     5 Alpha A01    2.69 35,000_c…         0 1 : Exper… 35000 HCME… ECIS      
#>  2     5 Alpha A02    2.89 35,000_c…         0 1 : Exper… 35000 HCME… ECIS      
#>  3     5 Alpha A03    2.71 35,000_c…         0 1 : Exper… 35000 HCME… ECIS      
#>  4     5 Alpha B01    2.52 30,000_c…         0 1 : Exper… 30000 HCME… ECIS      
#>  5     5 Alpha B02    2.69 30,000_c…         0 1 : Exper… 30000 HCME… ECIS      
#>  6     5 Alpha B03    2.34 30,000_c…         0 1 : Exper… 30000 HCME… ECIS      
#>  7     5 Alpha C01    2.15 25,000_c…         0 1 : Exper… 25000 HCME… ECIS      
#>  8     5 Alpha C02    2.35 25,000_c…         0 1 : Exper… 25000 HCME… ECIS      
#>  9     5 Alpha C03    2.4  25,000_c…         0 1 : Exper… 25000 HCME… ECIS      
#> 10     5 Alpha D01    1.85 20,000_c…         0 1 : Exper… 20000 HCME… ECIS      
#> # ℹ 139,220 more rows
#> # ℹ 2 more variables: SampleID <int>, Excluded <chr>
vascr_subset(growth.df, time = 40)
#> # A tibble: 3,570 × 12
#>     Time Unit  Well  Value Sample    Frequency Experiment cells line  Instrument
#>    <dbl> <chr> <chr> <dbl> <chr>         <dbl> <fct>      <chr> <chr> <chr>     
#>  1    40 Alpha A01    5.17 35,000_c…         0 1 : Exper… 35000 HCME… ECIS      
#>  2    40 Alpha A02    4.89 35,000_c…         0 1 : Exper… 35000 HCME… ECIS      
#>  3    40 Alpha A03    5.12 35,000_c…         0 1 : Exper… 35000 HCME… ECIS      
#>  4    40 Alpha B01    5.22 30,000_c…         0 1 : Exper… 30000 HCME… ECIS      
#>  5    40 Alpha B02    5.36 30,000_c…         0 1 : Exper… 30000 HCME… ECIS      
#>  6    40 Alpha B03    5.6  30,000_c…         0 1 : Exper… 30000 HCME… ECIS      
#>  7    40 Alpha C01    5.19 25,000_c…         0 1 : Exper… 25000 HCME… ECIS      
#>  8    40 Alpha C02    5.32 25,000_c…         0 1 : Exper… 25000 HCME… ECIS      
#>  9    40 Alpha C03    4.95 25,000_c…         0 1 : Exper… 25000 HCME… ECIS      
#> 10    40 Alpha D01    4.51 20,000_c…         0 1 : Exper… 20000 HCME… ECIS      
#> # ℹ 3,560 more rows
#> # ℹ 2 more variables: SampleID <int>, Excluded <chr>
vascr_subset(growth.df, time = NULL)
#> # A tibble: 139,230 × 12
#>     Time Unit  Well  Value Sample    Frequency Experiment cells line  Instrument
#>    <dbl> <chr> <chr> <dbl> <chr>         <dbl> <fct>      <chr> <chr> <chr>     
#>  1     5 Alpha A01    2.69 35,000_c…         0 1 : Exper… 35000 HCME… ECIS      
#>  2     5 Alpha A02    2.89 35,000_c…         0 1 : Exper… 35000 HCME… ECIS      
#>  3     5 Alpha A03    2.71 35,000_c…         0 1 : Exper… 35000 HCME… ECIS      
#>  4     5 Alpha B01    2.52 30,000_c…         0 1 : Exper… 30000 HCME… ECIS      
#>  5     5 Alpha B02    2.69 30,000_c…         0 1 : Exper… 30000 HCME… ECIS      
#>  6     5 Alpha B03    2.34 30,000_c…         0 1 : Exper… 30000 HCME… ECIS      
#>  7     5 Alpha C01    2.15 25,000_c…         0 1 : Exper… 25000 HCME… ECIS      
#>  8     5 Alpha C02    2.35 25,000_c…         0 1 : Exper… 25000 HCME… ECIS      
#>  9     5 Alpha C03    2.4  25,000_c…         0 1 : Exper… 25000 HCME… ECIS      
#> 10     5 Alpha D01    1.85 20,000_c…         0 1 : Exper… 20000 HCME… ECIS      
#> # ℹ 139,220 more rows
#> # ℹ 2 more variables: SampleID <int>, Excluded <chr>
 
vascr_subset(growth.df, unit = "Rb")
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
vascr_subset(growth.df, unit = "R")
#> # A tibble: 25,272 × 12
#>     Time Unit  Well  Value Sample    Frequency Experiment cells line  Instrument
#>    <dbl> <fct> <chr> <dbl> <chr>         <dbl> <fct>      <chr> <chr> <chr>     
#>  1     5 R     A01    413. 35,000_c…      1000 1 : Exper… 35000 HCME… ECIS      
#>  2    10 R     A01    470. 35,000_c…      1000 1 : Exper… 35000 HCME… ECIS      
#>  3    15 R     A01    556. 35,000_c…      1000 1 : Exper… 35000 HCME… ECIS      
#>  4    20 R     A01    630. 35,000_c…      1000 1 : Exper… 35000 HCME… ECIS      
#>  5    25 R     A01    677. 35,000_c…      1000 1 : Exper… 35000 HCME… ECIS      
#>  6    30 R     A01    695. 35,000_c…      1000 1 : Exper… 35000 HCME… ECIS      
#>  7    35 R     A01    729. 35,000_c…      1000 1 : Exper… 35000 HCME… ECIS      
#>  8    40 R     A01    768. 35,000_c…      1000 1 : Exper… 35000 HCME… ECIS      
#>  9    45 R     A01    801. 35,000_c…      1000 1 : Exper… 35000 HCME… ECIS      
#> 10    50 R     A01    815. 35,000_c…      1000 1 : Exper… 35000 HCME… ECIS      
#> # ℹ 25,262 more rows
#> # ℹ 2 more variables: SampleID <int>, Excluded <chr>
vascr_subset(growth.df, well = "A1")
#> # A tibble: 1,950 × 12
#>     Time Unit  Well  Value Sample    Frequency Experiment cells line  Instrument
#>    <dbl> <chr> <chr> <dbl> <chr>         <dbl> <fct>      <chr> <chr> <chr>     
#>  1     5 Alpha A01    2.69 35,000_c…         0 1 : Exper… 35000 HCME… ECIS      
#>  2     5 Cm    A01   37.9  35,000_c…         0 1 : Exper… 35000 HCME… ECIS      
#>  3     5 Drift A01   -0.94 35,000_c…         0 1 : Exper… 35000 HCME… ECIS      
#>  4     5 Rb    A01    0    35,000_c…         0 1 : Exper… 35000 HCME… ECIS      
#>  5     5 RMSE  A01    0.01 35,000_c…         0 1 : Exper… 35000 HCME… ECIS      
#>  6    10 Alpha A01    3.34 35,000_c…         0 1 : Exper… 35000 HCME… ECIS      
#>  7    10 Cm    A01   18.8  35,000_c…         0 1 : Exper… 35000 HCME… ECIS      
#>  8    10 Drift A01   -1.82 35,000_c…         0 1 : Exper… 35000 HCME… ECIS      
#>  9    10 Rb    A01    0    35,000_c…         0 1 : Exper… 35000 HCME… ECIS      
#> 10    10 RMSE  A01    0.02 35,000_c…         0 1 : Exper… 35000 HCME… ECIS      
#> # ℹ 1,940 more rows
#> # ℹ 2 more variables: SampleID <int>, Excluded <chr>

vascr_subset(growth.df, time = c(5,20))
#> # A tibble: 14,280 × 12
#>     Time Unit  Well  Value Sample    Frequency Experiment cells line  Instrument
#>    <dbl> <chr> <chr> <dbl> <chr>         <dbl> <fct>      <chr> <chr> <chr>     
#>  1     5 Alpha A01    2.69 35,000_c…         0 1 : Exper… 35000 HCME… ECIS      
#>  2     5 Alpha A02    2.89 35,000_c…         0 1 : Exper… 35000 HCME… ECIS      
#>  3     5 Alpha A03    2.71 35,000_c…         0 1 : Exper… 35000 HCME… ECIS      
#>  4     5 Alpha B01    2.52 30,000_c…         0 1 : Exper… 30000 HCME… ECIS      
#>  5     5 Alpha B02    2.69 30,000_c…         0 1 : Exper… 30000 HCME… ECIS      
#>  6     5 Alpha B03    2.34 30,000_c…         0 1 : Exper… 30000 HCME… ECIS      
#>  7     5 Alpha C01    2.15 25,000_c…         0 1 : Exper… 25000 HCME… ECIS      
#>  8     5 Alpha C02    2.35 25,000_c…         0 1 : Exper… 25000 HCME… ECIS      
#>  9     5 Alpha C03    2.4  25,000_c…         0 1 : Exper… 25000 HCME… ECIS      
#> 10     5 Alpha D01    1.85 20,000_c…         0 1 : Exper… 20000 HCME… ECIS      
#> # ℹ 14,270 more rows
#> # ℹ 2 more variables: SampleID <int>, Excluded <chr>
```
