# Combine ECIS data frames end to end

This function will combine ECIS data sets end to end. Preferential to
use over a simple rbind command as it runs additional checks to ensure
that data points are correctly generated

## Usage

``` r
vascr_combine(..., resample = FALSE)
```

## Arguments

- ...:

  List of data frames to be combined

- resample:

  Automatically try and re sample the data set. Default is FALSE

## Value

A single data frame containing all the data imported, automatically
incremented by experiment

## Examples

``` r
#Make three fake experiments worth of data
experiment1.df = vascr_subset(growth.df, experiment = "1")
#> ! [1] corrected to [2 : Experiment2]. Please check the argeuments for your functions are correctly typed.
experiment2.df = vascr_subset(growth.df, experiment = "2")
#> ! [2] corrected to [2 : Experiment2]. Please check the argeuments for your functions are correctly typed.
experiment3.df = vascr_subset(growth.df, experiment = "3")
#> ! [3] corrected to [3 : Experiment3]. Please check the argeuments for your functions are correctly typed.

data = vascr_combine(experiment1.df, experiment2.df, experiment3.df)
head(data)
#> # A tibble: 6 × 10
#>    Time Unit  Value Well  Sample        Frequency Experiment Instrument Excluded
#>   <dbl> <chr> <dbl> <chr> <chr>             <dbl> <fct>      <chr>      <chr>   
#> 1     5 Alpha  4.23 A04   35,000_cells…         0 1 : 2 : E… ECIS       no      
#> 2     5 Alpha  4.2  A05   35,000_cells…         0 1 : 2 : E… ECIS       no      
#> 3     5 Alpha  3.88 A06   35,000_cells…         0 1 : 2 : E… ECIS       no      
#> 4     5 Alpha  3.22 B04   30,000_cells…         0 1 : 2 : E… ECIS       no      
#> 5     5 Alpha  3.2  B05   30,000_cells…         0 1 : 2 : E… ECIS       no      
#> 6     5 Alpha  2.93 B06   30,000_cells…         0 1 : 2 : E… ECIS       no      
#> # ℹ 1 more variable: SampleID <int>

```
