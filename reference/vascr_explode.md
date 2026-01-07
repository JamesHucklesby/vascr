# Separate names in a vascr data frame

Separate names in a vascr data frame

## Usage

``` r
vascr_explode(data.df)
```

## Arguments

- data.df:

  the dataset to separate

## Value

a separated vascr dataset, with additional columns for each variable

## Examples

``` r
vascr_explode(growth.df)
#> # A tibble: 146,370 × 14
#>     Time Unit  Well  Value Sample  Frequency Experiment cells.x line  Instrument
#>    <dbl> <chr> <chr> <dbl> <chr>       <dbl> <fct>      <chr>   <chr> <chr>     
#>  1     0 Alpha A01      NA 35,000…         0 1 : Exper… 35000   HCME… ECIS      
#>  2     0 Alpha A02      NA 35,000…         0 1 : Exper… 35000   HCME… ECIS      
#>  3     0 Alpha A03      NA 35,000…         0 1 : Exper… 35000   HCME… ECIS      
#>  4     0 Alpha B01      NA 30,000…         0 1 : Exper… 30000   HCME… ECIS      
#>  5     0 Alpha B02      NA 30,000…         0 1 : Exper… 30000   HCME… ECIS      
#>  6     0 Alpha B03      NA 30,000…         0 1 : Exper… 30000   HCME… ECIS      
#>  7     0 Alpha C01      NA 25,000…         0 1 : Exper… 25000   HCME… ECIS      
#>  8     0 Alpha C02      NA 25,000…         0 1 : Exper… 25000   HCME… ECIS      
#>  9     0 Alpha C03      NA 25,000…         0 1 : Exper… 25000   HCME… ECIS      
#> 10     0 Alpha D01      NA 20,000…         0 1 : Exper… 20000   HCME… ECIS      
#> # ℹ 146,360 more rows
#> # ℹ 4 more variables: SampleID <int>, Excluded <chr>, cells.y <chr>,
#> #   D3_line <chr>
```
