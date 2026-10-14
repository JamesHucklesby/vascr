# Check the level of a vascr data frame

Check the level of a vascr data frame

## Usage

``` r
vascr_find_level(data)
```

## Arguments

- data:

  The data frame to analyse

## Value

The level of the dataset analysed

## Examples

``` r
vascr_find_level(growth.df)
#> [1] "wells"
vascr_find_level(vascr_summarise(growth.df %>% vascr_subset(unit= "Rb"), level = "experiments"))
#> [1] "experiments"
vascr_find_level(vascr_summarise(growth.df %>% vascr_subset(unit= "Rb"), level = "summary"))
#> [1] "summary"
```
