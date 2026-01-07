# Rename a sample in a vascr dataset

Renames samples in a vascr dataset, either replacing the whole sample or
parts of the string.

## Usage

``` r
vascr_edit_sample(data.df, change_list, partial = TRUE, escape = TRUE)
```

## Arguments

- data.df:

  Vascr dataset to update

- change_list:

  List of vectors containing pairs of search and replacement terms to
  replace

- partial:

  TRUE or FALSE, defines if partial matches should be changed

- escape:

  TRUE or FALSE, whether to escape special characters passed into the
  function

## Value

An updated vascr data frame

## Examples

``` r
to_rename = growth.df %>% vascr_subset(sample = c("0 cells","20,000 cells", "10,000 cells"))
#> ! [0 cells] corrected to [0_cells + HCMEC D3_line]. Please check the argeuments for your functions are correctly typed.
#> ! [20,000 cells] corrected to [20,000_cells + HCMEC D3_line]. Please check the argeuments for your functions are correctly typed.
#> ! [10,000 cells] corrected to [10,000_cells + HCMEC D3_line]. Please check the argeuments for your functions are correctly typed.

to_rename$Sample %>% unique()
#> [1] 20,000_cells + HCMEC D3_line 10,000_cells + HCMEC D3_line
#> [3] 0_cells + HCMEC D3_line     
#> 3 Levels: 0_cells + HCMEC D3_line ... 10,000_cells + HCMEC D3_line

renamed = vascr_edit_sample(to_rename, change_list = list(c("0_cells", "Cell Free")))
print(renamed$Sample %>% unique())
#> [1] 20,00Cell Free + HCMEC D3_line 10,00Cell Free + HCMEC D3_line
#> [3] Cell Free + HCMEC D3_line     
#> 3 Levels: Cell Free + HCMEC D3_line ... 10,00Cell Free + HCMEC D3_line
```
