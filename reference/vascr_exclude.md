# Exclude samples from a vascr dataset

Exclude samples from a vascr dataset

## Usage

``` r
vascr_exclude(data.df, well = NULL, experiment = NULL, sampleid = NULL)
```

## Arguments

- data.df:

  the vascr data set to exclude things from

- well:

  wells to exclude

- experiment:

  experiments to exclude

- sampleid:

  sampleID (or vector or sampleIDs) to exclude from analysis

## Value

A smaller vascr dataset

## Examples

``` r
vascr_exclude(growth.df, c("A01", "E01"))
#> # A tibble: 142,270 × 12
#>     Time Unit  Well  Value Sample    Frequency Experiment cells line  Instrument
#>    <dbl> <chr> <chr> <dbl> <chr>         <dbl> <fct>      <chr> <chr> <chr>     
#>  1     0 Alpha A02      NA 35,000_c…         0 1 : Exper… 35000 HCME… ECIS      
#>  2     0 Alpha A03      NA 35,000_c…         0 1 : Exper… 35000 HCME… ECIS      
#>  3     0 Alpha B01      NA 30,000_c…         0 1 : Exper… 30000 HCME… ECIS      
#>  4     0 Alpha B02      NA 30,000_c…         0 1 : Exper… 30000 HCME… ECIS      
#>  5     0 Alpha B03      NA 30,000_c…         0 1 : Exper… 30000 HCME… ECIS      
#>  6     0 Alpha C01      NA 25,000_c…         0 1 : Exper… 25000 HCME… ECIS      
#>  7     0 Alpha C02      NA 25,000_c…         0 1 : Exper… 25000 HCME… ECIS      
#>  8     0 Alpha C03      NA 25,000_c…         0 1 : Exper… 25000 HCME… ECIS      
#>  9     0 Alpha D01      NA 20,000_c…         0 1 : Exper… 20000 HCME… ECIS      
#> 10     0 Alpha D02      NA 20,000_c…         0 1 : Exper… 20000 HCME… ECIS      
#> # ℹ 142,260 more rows
#> # ℹ 2 more variables: SampleID <int>, Excluded <chr>
vascr_exclude(growth.df, sampleid = 1)
#> # A tibble: 127,920 × 12
#>     Time Unit  Well  Value Sample    Frequency Experiment cells line  Instrument
#>    <dbl> <chr> <chr> <dbl> <chr>         <dbl> <fct>      <chr> <chr> <chr>     
#>  1     0 Alpha B01      NA 30,000_c…         0 1 : Exper… 30000 HCME… ECIS      
#>  2     0 Alpha B02      NA 30,000_c…         0 1 : Exper… 30000 HCME… ECIS      
#>  3     0 Alpha B03      NA 30,000_c…         0 1 : Exper… 30000 HCME… ECIS      
#>  4     0 Alpha C01      NA 25,000_c…         0 1 : Exper… 25000 HCME… ECIS      
#>  5     0 Alpha C02      NA 25,000_c…         0 1 : Exper… 25000 HCME… ECIS      
#>  6     0 Alpha C03      NA 25,000_c…         0 1 : Exper… 25000 HCME… ECIS      
#>  7     0 Alpha D01      NA 20,000_c…         0 1 : Exper… 20000 HCME… ECIS      
#>  8     0 Alpha D02      NA 20,000_c…         0 1 : Exper… 20000 HCME… ECIS      
#>  9     0 Alpha D03      NA 20,000_c…         0 1 : Exper… 20000 HCME… ECIS      
#> 10     0 Alpha E01      NA 15,000_c…         0 1 : Exper… 15000 HCME… ECIS      
#> # ℹ 127,910 more rows
#> # ℹ 2 more variables: SampleID <int>, Excluded <chr>

```
