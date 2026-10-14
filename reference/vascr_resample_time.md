# Resample a vascr dataset

Impedance sensing data is often not collected simultaneously, which
creates issues summarising and plotting the data. This function
interpolates these data to allow these downstream functions to happen.

## Usage

``` r
vascr_resample_time(
  data.df,
  npoints = vascr_find_count_timepoints(data.df),
  t_start = min(data.df$Time),
  t_end = max(data.df$Time),
  rate = NULL,
  force_timepoint = NULL,
  include_disc = TRUE
)
```

## Arguments

- data.df:

  The vascr dataset to resample

- npoints:

  Manually specificity the number of points to resample at, default is
  the same frequency as the input dataset

- t_start:

  Time to start at

- t_end:

  Time to end at

- rate:

  Time between timepoints

- force_timepoint:

  Force a specific timepoint to be part of the resample

- include_disc:

  Add an additional data point either side of a discrepancy. Defaults
  TRUE

## Value

An interpolated vascr dataset

## Examples

``` r
# Automatically re sample, mimicking the input data as closely as possible
vascr_resample_time(growth.df)
#> # A tibble: 146,370 × 12
#>    Unit  Well  Sample       Frequency Experiment cells line  Instrument SampleID
#>    <chr> <chr> <chr>            <dbl> <fct>      <chr> <chr> <chr>         <int>
#>  1 Alpha A01   35,000_cell…         0 1 : Exper… 35000 HCME… ECIS              1
#>  2 Alpha A01   35,000_cell…         0 1 : Exper… 35000 HCME… ECIS              1
#>  3 Alpha A01   35,000_cell…         0 1 : Exper… 35000 HCME… ECIS              1
#>  4 Alpha A01   35,000_cell…         0 1 : Exper… 35000 HCME… ECIS              1
#>  5 Alpha A01   35,000_cell…         0 1 : Exper… 35000 HCME… ECIS              1
#>  6 Alpha A01   35,000_cell…         0 1 : Exper… 35000 HCME… ECIS              1
#>  7 Alpha A01   35,000_cell…         0 1 : Exper… 35000 HCME… ECIS              1
#>  8 Alpha A01   35,000_cell…         0 1 : Exper… 35000 HCME… ECIS              1
#>  9 Alpha A01   35,000_cell…         0 1 : Exper… 35000 HCME… ECIS              1
#> 10 Alpha A01   35,000_cell…         0 1 : Exper… 35000 HCME… ECIS              1
#> # ℹ 146,360 more rows
#> # ℹ 3 more variables: Excluded <chr>, Value <dbl>, Time <dbl>

# Fully controlled resample with advanced options
vascr_resample_time(growth.df, t_start = 5, t_end = 20, rate = 5, force = c(1,2,3))
#> # A tibble: 24,990 × 12
#>    Unit  Well  Sample       Frequency Experiment cells line  Instrument SampleID
#>    <chr> <chr> <chr>            <dbl> <fct>      <chr> <chr> <chr>         <int>
#>  1 Alpha A01   35,000_cell…         0 1 : Exper… 35000 HCME… ECIS              1
#>  2 Alpha A01   35,000_cell…         0 1 : Exper… 35000 HCME… ECIS              1
#>  3 Alpha A01   35,000_cell…         0 1 : Exper… 35000 HCME… ECIS              1
#>  4 Alpha A01   35,000_cell…         0 1 : Exper… 35000 HCME… ECIS              1
#>  5 Alpha A01   35,000_cell…         0 1 : Exper… 35000 HCME… ECIS              1
#>  6 Alpha A01   35,000_cell…         0 1 : Exper… 35000 HCME… ECIS              1
#>  7 Alpha A01   35,000_cell…         0 1 : Exper… 35000 HCME… ECIS              1
#>  8 Alpha A02   35,000_cell…         0 1 : Exper… 35000 HCME… ECIS              1
#>  9 Alpha A02   35,000_cell…         0 1 : Exper… 35000 HCME… ECIS              1
#> 10 Alpha A02   35,000_cell…         0 1 : Exper… 35000 HCME… ECIS              1
#> # ℹ 24,980 more rows
#> # ℹ 3 more variables: Excluded <chr>, Value <dbl>, Time <dbl>
```
