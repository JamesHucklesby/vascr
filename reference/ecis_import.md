# Import all ECIS values, a child of ecis_import_raw and ecis_import_model

Import all ECIS values, a child of ecis_import_raw and ecis_import_model

## Usage

``` r
ecis_import(raw = NULL, modeled = NULL, experimentname = NULL)
```

## Arguments

- raw:

  A raw ABP file to import

- modeled:

  A modeled APB file for import

- experimentname:

  Name of the experiment to be built into the dataset

## Value

A data frame containing all the data APB generated from an experiment

## Examples

``` r
raw = system.file('extdata/instruments/ecis_TimeResample.abp', package = 'vascr')
modeled = system.file('extdata/instruments/ecis_TimeResample_RbA.csv', package = 'vascr')
experimentname = "TEST"

#Then run the import

data = ecis_import(raw ,modeled,experimentname)
#> ℹ Starting import
#> ℹ Importing raw data
#> ℹ Reading file
#> ℹ Extracting data
#> ℹ Lengthening the dataset
#> ℹ Generating other physical quantaties
#> ℹ Cleaning up
#> ℹ Importing model data
#> ℹ Reading file into R
#> ℹ Extracting useful data
#> ℹ Renaming units
#> ℹ Naming dataset
#> ℹ Creating long dataframe
#> ℹ Finishing up
#> ✔ Import complete
#head(data)
```
