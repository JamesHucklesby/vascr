# Apply a map to a vascr dataset

Apply a map to a vascr dataset

## Usage

``` r
vascr_apply_map(data.df, map)
```

## Arguments

- data.df:

  the dataset to apply to

- map:

  the dataset to apply

## Value

a named vascr dataset

## Examples

``` r
lookup = system.file('extdata/instruments/eciskey.csv', package = 'vascr')
vascr_apply_map(data.df = growth.df, map = lookup)
#> ! Wells found in imported data but not map: A02 A03 B02 B03 C02 C03 D01 D02 D03 E01 E03 F01 F03 G01 G03 H01 H02 H03 A04 A05 A06 B04 B05 B06 C04 C05 C06 D04 D05 D06 E04 E05 E06 F04 F05 F06 G04 G05 G06 H04 H05 H06 A07 A08 A09 B07 B08 B09 C07 C08 C09 D07 D08 D09 E07 E08 E09 F07 F08 F09 G07 G08 G09 H07 H08 H09
#> Joining with `by = join_by(Well)`
#> # A tibble: 146,370 × 14
#>     Time Unit  Well  Value Frequency Experiment  cells line  Instrument Excluded
#>    <dbl> <chr> <chr> <dbl>     <dbl> <fct>       <chr> <chr> <chr>      <chr>   
#>  1     0 Alpha A01      NA         0 1 : Experi… 35000 HCME… ECIS       no      
#>  2     0 Alpha A02      NA         0 1 : Experi… 35000 HCME… ECIS       no      
#>  3     0 Alpha A03      NA         0 1 : Experi… 35000 HCME… ECIS       no      
#>  4     0 Alpha B01      NA         0 1 : Experi… 30000 HCME… ECIS       no      
#>  5     0 Alpha B02      NA         0 1 : Experi… 30000 HCME… ECIS       no      
#>  6     0 Alpha B03      NA         0 1 : Experi… 30000 HCME… ECIS       no      
#>  7     0 Alpha C01      NA         0 1 : Experi… 25000 HCME… ECIS       no      
#>  8     0 Alpha C02      NA         0 1 : Experi… 25000 HCME… ECIS       no      
#>  9     0 Alpha C03      NA         0 1 : Experi… 25000 HCME… ECIS       no      
#> 10     0 Alpha D01      NA         0 1 : Experi… 20000 HCME… ECIS       no      
#> # ℹ 146,360 more rows
#> # ℹ 4 more variables: SampleID <int>, Sample <fct>, Vehicle <chr>, HCMVEC <chr>

vascr_apply_map(growth.df %>% vascr_subset(well = c("A1")), lookup)
#> ! Wells found in map but not imported data: NA NA NA NA NA
#> Joining with `by = join_by(Well)`
#> # A tibble: 1,950 × 14
#>     Time Unit  Well  Value Frequency Experiment  cells line  Instrument Excluded
#>    <dbl> <chr> <chr> <dbl>     <dbl> <fct>       <chr> <chr> <chr>      <chr>   
#>  1     5 Alpha A01    2.69         0 1 : Experi… 35000 HCME… ECIS       no      
#>  2     5 Cm    A01   37.9          0 1 : Experi… 35000 HCME… ECIS       no      
#>  3     5 Drift A01   -0.94         0 1 : Experi… 35000 HCME… ECIS       no      
#>  4     5 Rb    A01    0            0 1 : Experi… 35000 HCME… ECIS       no      
#>  5     5 RMSE  A01    0.01         0 1 : Experi… 35000 HCME… ECIS       no      
#>  6    10 Alpha A01    3.34         0 1 : Experi… 35000 HCME… ECIS       no      
#>  7    10 Cm    A01   18.8          0 1 : Experi… 35000 HCME… ECIS       no      
#>  8    10 Drift A01   -1.82         0 1 : Experi… 35000 HCME… ECIS       no      
#>  9    10 Rb    A01    0            0 1 : Experi… 35000 HCME… ECIS       no      
#> 10    10 RMSE  A01    0.02         0 1 : Experi… 35000 HCME… ECIS       no      
#> # ℹ 1,940 more rows
#> # ℹ 4 more variables: SampleID <int>, Sample <fct>, Vehicle <chr>, HCMVEC <chr>
```
