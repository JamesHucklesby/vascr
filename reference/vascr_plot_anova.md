# Make a display with all the ANOVA analysis pre-conducted

Make a display with all the ANOVA analysis pre-conducted

## Usage

``` r
vascr_plot_anova(
  data.df,
  unit,
  frequency,
  time,
  reference = NULL,
  separate = "x",
  rotate = 45
)
```

## Arguments

- data.df:

  vascr dataset to plot

- unit:

  unit to plot

- frequency:

  frequency to plot

- time:

  timepoint to plot at

- reference:

  Sample to reference post-hoc analysis to

- separate:

  Value to use when separating comparasons in the output (default x)

- rotate:

  degrees of rotation used for labeling the X axis

## Value

A matrix of different ANOVA tests

## Examples

``` r
# \donttest{
# Run, comparing only to a reference
vascr_plot_anova(data.df = small_growth.df, unit = "R", frequency = 4000, time = 100, 
          reference = "5,000_cells + HCMEC D3_line")
#> ! [ 100 ]  corrected to  [ 88.8888888888889 ]. Please check the variables used.
#> Warning: `fortify(<lm>)` was deprecated in ggplot2 4.0.0.
#> ℹ Please use `broom::augment(<lm>)` instead.
#> ℹ The deprecated feature was likely used in the ggplot2 package.
#>   Please report the issue at <https://github.com/tidyverse/ggplot2/issues>.
#> ! [ 88.8888888888889 ]  corrected to  [ 88.8888888888889 ]. Please check the variables used.
#> ! [ 88.8888888888889 ]  corrected to  [ 88.8889 ]. Please check the variables used.
#> Warning: Removed 1 row containing missing values or values outside the scale range
#> (`geom_text_repel()`).

# }
```
