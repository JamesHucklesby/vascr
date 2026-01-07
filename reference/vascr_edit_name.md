# Edit a sample name in a vascr dataframe

Edit a sample name in a vascr dataframe

## Usage

``` r
vascr_edit_name(data.df, to_remove, to_add = "")
```

## Arguments

- data.df:

  The data set to edit

- to_remove:

  The sample to remove

- to_add:

  The sample to replace with

## Value

An edited vascr dataset

## Examples

``` r
vascr_edit_name(growth.df,"HCMEC D3", "HCMEC/D3")
#> # A tibble: 146,370 × 12
#>    Sample     Time Unit  Well  Value Frequency Experiment cells line  Instrument
#>    <chr>     <dbl> <chr> <chr> <dbl>     <dbl> <fct>      <chr> <chr> <chr>     
#>  1 35,000_c…     0 Alpha A01      NA         0 1 : Exper… 35000 HCME… ECIS      
#>  2 35,000_c…     0 Alpha A02      NA         0 1 : Exper… 35000 HCME… ECIS      
#>  3 35,000_c…     0 Alpha A03      NA         0 1 : Exper… 35000 HCME… ECIS      
#>  4 35,000_c…     0 Cm    A01      NA         0 1 : Exper… 35000 HCME… ECIS      
#>  5 35,000_c…     0 Cm    A02      NA         0 1 : Exper… 35000 HCME… ECIS      
#>  6 35,000_c…     0 Cm    A03      NA         0 1 : Exper… 35000 HCME… ECIS      
#>  7 35,000_c…     0 Drift A01      NA         0 1 : Exper… 35000 HCME… ECIS      
#>  8 35,000_c…     0 Drift A02      NA         0 1 : Exper… 35000 HCME… ECIS      
#>  9 35,000_c…     0 Drift A03      NA         0 1 : Exper… 35000 HCME… ECIS      
#> 10 35,000_c…     0 Rb    A01      NA         0 1 : Exper… 35000 HCME… ECIS      
#> # ℹ 146,360 more rows
#> # ℹ 2 more variables: SampleID <int>, Excluded <chr>
```
