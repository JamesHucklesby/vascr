# List out the samples currently in a vascr data set

List out the samples currently in a vascr data set

## Usage

``` r
vascr_samples(data.df)
```

## Arguments

- data.df:

  The vascr data set to analyse

## Value

A printout of the samples, Sample ID's and experiments where they occur

## Examples

``` r
vascr_samples(growth.df)
#> # A tibble: 8 × 3
#>   SampleID Sample                       Experiment                              
#>      <int> <chr>                        <chr>                                   
#> 1        8 0_cells + HCMEC D3_line      1 : Experiment 1 H01 H02 H03 | 2 : Expe…
#> 2        6 10,000_cells + HCMEC D3_line 1 : Experiment 1 F01 F02 F03 | 2 : Expe…
#> 3        5 15,000_cells + HCMEC D3_line 1 : Experiment 1 E01 E02 E03 | 2 : Expe…
#> 4        4 20,000_cells + HCMEC D3_line 1 : Experiment 1 D01 D02 D03 | 2 : Expe…
#> 5        3 25,000_cells + HCMEC D3_line 1 : Experiment 1 C01 C02 C03 | 2 : Expe…
#> 6        2 30,000_cells + HCMEC D3_line 1 : Experiment 1 B01 B02 B03 | 2 : Expe…
#> 7        1 35,000_cells + HCMEC D3_line 1 : Experiment 1 A01 A02 A03 | 2 : Expe…
#> 8        7 5,000_cells + HCMEC D3_line  1 : Experiment 1 G01 G02 G03 | 2 : Expe…
```
