# Find vascr variables

These functions are utility functions that will detect if arguments are
invalid, and attempt to repair them. Each type of variable has rules
related to what values are possible in a valid vascr dataset.

## Usage

``` r
vascr_find(data.df = vascr::growth.df, paramater, value = NA)
```

## Arguments

- data.df:

  The vascr dataset to reference, will default to the growth.df dataset
  if not specified

- paramater:

  The parameter to search. Options are "Time", "Unit", "Well",
  "Frequency", "Sample", "Experiment", "SampleID" or "resampled"

- value:

  the value to look up

## Value

The valid vascr dataset.

## Examples

``` r
vascr_find(growth.df, "Time")
#> [1] 100
vascr_find(growth.df, "Time", 66.97)
#> ! [ 66.97 ]  corrected to  [ 65 ]. Please check the variables used.
#> [1] 65
vascr_find(growth.df, "Time", NULL)
#>  [1]   0   5  10  15  20  25  30  35  40  45  50  55  60  65  70  75  80  85  90
#> [20]  95 100 105 110 115 120 125 130 135 140 145 150 155 160 165 170 175 180 185
#> [39] 190 195 200

vascr_find(growth.df, "Unit")
#> [1] "R"
vascr_find(growth.df, "Unit", "Rb")
#> [1] "Rb"
vascr_find(growth.df, "Unit", NULL)
#>  [1] "Alpha" "Cm"    "Drift" "Rb"    "RMSE"  "C"     "P"     "R"     "X"    
#> [10] "Z"    

vascr_find(growth.df, "Well")
#> ! Well NA is not a valid well name, please check your input data
#> ! [NA] corrected to [A01]. Please check the argeuments for your functions are correctly typed.
#> [1] "A01"
vascr_find(growth.df, "Well", "A1")
#> [1] "A01"

vascr_find(growth.df, "Sample")
#> [1] "35,000_cells + HCMEC D3_line"
vascr_find(growth.df, "Sample", "5000 cells")
#> ! [5000 cells] corrected to [5,000_cells + HCMEC D3_line]. Please check the argeuments for your functions are correctly typed.
#> [1] "5,000_cells + HCMEC D3_line"

vascr_find(growth.df, "Frequency")
#> [1] 4000
vascr_find(growth.df, "Frequency", 4000)
#> [1] 4000

vascr_find(growth.df, "Experiment")
#> ! [NA] corrected to [1 : Experiment 1]. Please check the argeuments for your functions are correctly typed.
#> [1] "1 : Experiment 1"
vascr_find(growth.df, "Experiment", 1)
#> [1] "1 : Experiment 1"

vascr_find(growth.df, "SampleID")
#> ✖ Sample ID not found
#> [1] NA
vascr_find(growth.df, "SampleID", 5)
#> [1] 5

vascr_find(growth.df, "resampled")
#> [1] TRUE

vascr_find(growth.df, "all")
#> 
#> Timepoints
#> [1] "cli-150-625"
```
