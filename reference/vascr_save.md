# Save a vascr dataset

Save a vascr dataset

## Usage

``` r
vascr_save(data.df, path)
```

## Arguments

- data.df:

  The vascr dataset to save

- path:

  The path to save the file to

## Value

A .vascr file containing a vascr dataset

## Examples

``` r
path = tempfile()
vascr_save(growth.df, path = path)
```
