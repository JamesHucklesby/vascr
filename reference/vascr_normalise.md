# Normalize ECIS data to a single time point

This function normalises each unique experiment/well combination to it's
value at the specified time. Contains options to do this either by
division or subtraction. Can be run twice on the same dataset if both
operations are desired.

## Usage

``` r
vascr_normalise(data.df, normtime, divide = FALSE)
```

## Arguments

- data.df:

  Standard vascr data frame

- normtime:

  Time to normalize the data to

- divide:

  If set to true, data will be normalized via a division. If set to
  false (default) data will be normalized by subtraction. Default is
  subtraction

## Value

A standard ECIS dataset with each value normalized to the selected
point.

## Examples

``` r
data = vascr_normalise(growth.df, normtime = 100)
#> ! NaN values or infinities generated in normalisation. Proceed with caution
head(data)
#> # A tibble: 6 × 10
#>    Time Unit  Value Well  Sample        Frequency Experiment Instrument SampleID
#>   <dbl> <chr> <dbl> <chr> <chr>             <dbl> <fct>      <chr>         <int>
#> 1     0 Alpha    NA A01   35,000_cells…         0 1 : Exper… ECIS              1
#> 2     0 Alpha    NA A02   35,000_cells…         0 1 : Exper… ECIS              1
#> 3     0 Alpha    NA A03   35,000_cells…         0 1 : Exper… ECIS              1
#> 4     0 Alpha    NA B01   30,000_cells…         0 1 : Exper… ECIS              2
#> 5     0 Alpha    NA B02   30,000_cells…         0 1 : Exper… ECIS              2
#> 6     0 Alpha    NA B03   30,000_cells…         0 1 : Exper… ECIS              2
#> # ℹ 1 more variable: Excluded <chr>
```
