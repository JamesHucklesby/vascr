# Implode individual samples from a vascr dataset

Implode individual samples from a vascr dataset

## Usage

``` r
vascr_implode(data.df, cols = NULL)
```

## Arguments

- data.df:

  A vascr dataset to be imploded

- cols:

  The columns to implode

## Value

A vascr dataset with individual wells imploded

## Examples

``` r
vascr_implode(growth.df)
#> # A tibble: 146,370 × 12
#>    SampleID Sample       Time Unit  Well  Value Frequency Experiment cells line 
#>       <int> <chr>       <dbl> <chr> <chr> <dbl>     <dbl> <fct>      <chr> <chr>
#>  1        1 35000 cell…     0 Alpha A01      NA         0 1 : Exper… 35000 HCME…
#>  2        1 35000 cell…     0 Alpha A02      NA         0 1 : Exper… 35000 HCME…
#>  3        1 35000 cell…     0 Alpha A03      NA         0 1 : Exper… 35000 HCME…
#>  4        1 35000 cell…     0 Cm    A01      NA         0 1 : Exper… 35000 HCME…
#>  5        1 35000 cell…     0 Cm    A02      NA         0 1 : Exper… 35000 HCME…
#>  6        1 35000 cell…     0 Cm    A03      NA         0 1 : Exper… 35000 HCME…
#>  7        1 35000 cell…     0 Drift A01      NA         0 1 : Exper… 35000 HCME…
#>  8        1 35000 cell…     0 Drift A02      NA         0 1 : Exper… 35000 HCME…
#>  9        1 35000 cell…     0 Drift A03      NA         0 1 : Exper… 35000 HCME…
#> 10        1 35000 cell…     0 Rb    A01      NA         0 1 : Exper… 35000 HCME…
#> # ℹ 146,360 more rows
#> # ℹ 2 more variables: Instrument <chr>, Excluded <chr>
```
