# Load a vascr dataset

Load a vascr dataset

## Usage

``` r
vascr_load(path)
```

## Arguments

- path:

  the path to a .vascr file containing the saved dataset

## Value

A vascr dataset

## Examples

``` r
path = system.file("extdata/test.vascr", package = "vascr")
vascr_load(path)
#> Loading objects:
#>   small_growth.df
```
