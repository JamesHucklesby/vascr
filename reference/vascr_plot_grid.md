# Plot out each replicate well in a grid, with QC overlays

Plot out each replicate well in a grid, with QC overlays

## Usage

``` r
vascr_plot_grid(data.df, threshold = 0.2)
```

## Arguments

- data.df:

  a vascr formatted data frame of single values

- threshold:

  threshold at which a data point is determined to be an outlier

## Value

A plot to be used for QC

## Examples

``` r
grid.df = growth.df %>% vascr_subset(unit = "R", frequency = "4000", experiment  = 1)
vascr_plot_grid(grid.df)

```
