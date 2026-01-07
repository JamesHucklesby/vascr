# Export a vascr dataframe

Export a vascr dataframe

## Usage

``` r
vascr_export_prism(
  data.df,
  filepath = tempfile("test_export", fileext = ".xlsx"),
  level = "experiments"
)
```

## Arguments

- data.df:

  a vascr dataset to export

- filepath:

  Path to save the dataframe in

- level:

  Level of replication to export, defaults to experiments

## Value

A dataframe in prism format, or writes to file if filepath specified

## Examples

``` r
filepath = tempfile("test_export", fileext = ".xlsx")
to_export = growth.df %>% vascr_subset(unit = c("R", "Rb"), frequency = c(0,4000))
vascr_export_prism(to_export, filepath)

vascr_export_prism(to_export, filepath, level = "wells")
```
