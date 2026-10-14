# Plot the data re sampling process

Plot the data re sampling process

## Usage

``` r
vascr_plot_resample(
  data.df,
  unit = "R",
  frequency = "4000",
  well = "A01",
  newn = 20,
  plot = TRUE,
  rug = TRUE,
  points = FALSE
)
```

## Arguments

- data.df:

  Dataset to analyse

- unit:

  Unit to use, defaults to R

- frequency:

  Frequency to use, defaults to 4000

- well:

  Well to use, defaults to A01 (or first well in plate)

- newn:

  New number of timepoints to compare to current

- plot:

  Return a ggplot or the underlying data. Defaults to TRUE, returning
  the plot.

- rug:

  Show rug lot, defaults true

- points:

  Show points, defaults to false

## Value

A plot showing how well the resampled data conforms to the actual data
set

## Examples

``` r
vascr_plot_resample(growth.df)

vascr_plot_resample(growth.df, plot = FALSE)
#>    n     d_auc        r2       ccf
#> 1 20 0.9984047 0.9990258 0.9995361

```
