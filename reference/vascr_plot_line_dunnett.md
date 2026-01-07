# Create a line plot with Dunnett's statistics

Create a line plot with Dunnett's statistics

## Usage

``` r
vascr_plot_line_dunnett(
  data.df,
  unit = "R",
  frequency = 4000,
  time = 100,
  reference = "0_cells + HCMEC D3_Line",
  normtime = NULL
)
```

## Arguments

- data.df:

  A vascr dataset

- unit:

  Unit to calculate

- frequency:

  Frequency to calculate from

- time:

  Time to calculate

- reference:

  Sample to reference testing against

- normtime:

  Time to normalise the line plot to, note this does not affect
  underlying statistical test

## Value

A line plot, annotated with the P-values determined by Dunnett's test

## Examples

``` r
vascr_plot_line_dunnett(small_growth.df, unit = "R", frequency = 4000, time = 25, 
    reference = "0_cells + HCMEC D3_Line")
#> ! [ 25 ]  corrected to  [ 22.2222222222222 ]. Please check the variables used.
#> ! [ 25 ]  corrected to  [ 22.2222222222222 ]. Please check the variables used.
#> ! [ 25 ]  corrected to  [ 22.2222 ]. Please check the variables used.
#> Warning: Removed 8 rows containing missing values or values outside the scale range
#> (`geom_text_repel()`).

vascr_plot_line_dunnett(small_growth.df, unit = "R", frequency = 4000, time = list(25,100), 
    reference = "0_cells + HCMEC D3_Line")
#> ! [ 25 ]  corrected to  [ 22.2222222222222 ]. Please check the variables used.
#> ! [ 100 ]  corrected to  [ 88.8888888888889 ]. Please check the variables used.
#> ! [ 25 ]  corrected to  [ 22.2222222222222 ]. Please check the variables used.
#> ! [ 100 ]  corrected to  [ 88.8888888888889 ]. Please check the variables used.
#> ! [ 25 ]  corrected to  [ 22.2222 ]. Please check the variables used.
#> ! [ 100 ]  corrected to  [ 88.8889 ]. Please check the variables used.
#> Warning: Removed 16 rows containing missing values or values outside the scale range
#> (`geom_text_repel()`).

vascr_plot_line_dunnett(small_growth.df, unit = "R", frequency = 4000, time = 180, 
    reference = "20,000_cells + HCMEC D3_Line")
#> ! [ 180 ]  corrected to  [ 177.777777777778 ]. Please check the variables used.
#> ! [ 180 ]  corrected to  [ 177.777777777778 ]. Please check the variables used.
#> ! [ 180 ]  corrected to  [ 177.7778 ]. Please check the variables used.
#> Warning: Removed 8 rows containing missing values or values outside the scale range
#> (`geom_text_repel()`).

```
