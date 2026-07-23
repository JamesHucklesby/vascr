# Run ANOVA and Dunnett's comparisons on a vascr dataset

Run ANOVA and Dunnett's comparisons on a vascr dataset

Run ANOVA and Dunnett's comparisons on a vascr dataset

## Usage

``` r
vascr_dunnett(data.df, unit, frequency, time, reference)

vascr_dunnett(data.df, unit, frequency, time, reference)
```

## Arguments

- data.df:

  A vascr dataset

- unit:

  The unit to plot

- frequency:

  The frequency to plot

- time:

  The time to plot

- reference:

  Reference sample to compare against. If all comparisons are needed use
  vascr_anova

## Value

A table with the results of the Dunnett's test

A table with the results of the Dunnett's test

## Examples

``` r
vascr_dunnett(data.df = growth.df, unit = "R", frequency = 4000, time = 100, reference = 6)
#> Error in loadNamespace(x): there is no package called ‘emmeans’
vascr_dunnett(growth.df, "R", 4000, time = list(50, 100), 6)
#> Error in loadNamespace(x): there is no package called ‘emmeans’

vascr_dunnett(data.df = growth.df, unit = "R", frequency = 4000, time = 100, reference = 6)
#> Error in loadNamespace(x): there is no package called ‘emmeans’
vascr_dunnett(growth.df, "R", 4000, time = list(50, 100), 6)
#> Error in loadNamespace(x): there is no package called ‘emmeans’
```
