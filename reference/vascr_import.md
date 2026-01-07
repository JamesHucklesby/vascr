# Import an impedance datafile to vascr

Import an impedance datafile to vascr

## Usage

``` r
vascr_import(
  instrument = NULL,
  raw = NULL,
  modeled = NULL,
  experiment = NULL,
  shear = FALSE
)
```

## Arguments

- instrument:

  Instrument to import from, either ECIS, xCELLigence or cellZscope

- raw:

  Path to raw data file

- modeled:

  Path to modeled data file from manufacturer's software

- experiment:

  Name for the experiment being imported

- shear:

  True or False, is a shear plate used, as these have a different
  electrode layout. Defaults to False.

## Value

A vascr dataset for subsequent analysis

## Examples

``` r
# \donttest{

# ECIS
raw = system.file('extdata/instruments/ecis_TimeResample.abp', package = 'vascr')
modeled = system.file('extdata/instruments/ecis_TimeResample_RbA.csv', package = 'vascr')
vascr_import("ECIS", raw, modeled, "ECIS_Data")
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
#> # A tibble: 14,400 × 9
#>     Time Well  Frequency Unit  Value Instrument Experiment Excluded Sample
#>    <dbl> <chr>     <dbl> <fct> <dbl> <chr>      <chr>      <chr>    <chr> 
#>  1     0 A01        1000 R      394. ECIS       ECIS_Data  no       NA    
#>  2     0 A01       16000 R      223. ECIS       ECIS_Data  no       NA    
#>  3     0 A01        2000 R      316. ECIS       ECIS_Data  no       NA    
#>  4     0 A01         250 R      824. ECIS       ECIS_Data  no       NA    
#>  5     0 A01       32000 R      212. ECIS       ECIS_Data  no       NA    
#>  6     0 A01        4000 R      267. ECIS       ECIS_Data  no       NA    
#>  7     0 A01         500 R      533. ECIS       ECIS_Data  no       NA    
#>  8     0 A01       64000 R      205. ECIS       ECIS_Data  no       NA    
#>  9     0 A01        8000 R      240. ECIS       ECIS_Data  no       NA    
#> 10     0 B01        1000 R      388. ECIS       ECIS_Data  no       NA    
#> # ℹ 14,390 more rows

# xCELLigence
raw = system.file('extdata/instruments/xcell.plt', package = 'vascr')
# No modeling for this system
vascr_import("xCELLigence", raw, experiment = "xCELLigence")
#> Connection not found. Returning NULL.
#> Error: unable to find an inherited method for function ‘dbReadTable’ for signature ‘conn = "NULL", name = "character"’

# cellZscope
model = system.file("extdata/instruments/zscopemodel.txt", package = "vascr")
raw = system.file("extdata/instruments/zscoperaw.txt", package = "vascr")
vascr_import("cellzscope", raw, model, "cellZscope")
#> # A tibble: 88,288 × 8
#>     Time Unit               Well  Value Experiment Frequency Instrument Sample  
#>    <dbl> <chr>              <chr> <dbl> <chr>          <dbl> <chr>      <chr>   
#>  1  0.03 CPE_A(sⁿ⁻¹·µF/cm²) A01    NA   cellZscope         0 cellZscope " 80,00…
#>  2  0.03 CPE_A(sⁿ⁻¹·µF/cm²) A02    46.8 cellZscope         0 cellZscope " 80,00…
#>  3  0.03 CPE_A(sⁿ⁻¹·µF/cm²) A04    42.9 cellZscope         0 cellZscope " 20,00…
#>  4  0.03 CPE_A(sⁿ⁻¹·µF/cm²) A05    NA   cellZscope         0 cellZscope " 20,00…
#>  5  0.03 CPE_A(sⁿ⁻¹·µF/cm²) B01    NA   cellZscope         0 cellZscope " 80,00…
#>  6  0.03 CPE_A(sⁿ⁻¹·µF/cm²) B02    NA   cellZscope         0 cellZscope " 80,00…
#>  7  0.03 CPE_A(sⁿ⁻¹·µF/cm²) B04    NA   cellZscope         0 cellZscope " 20,00…
#>  8  0.03 CPE_A(sⁿ⁻¹·µF/cm²) B05    NA   cellZscope         0 cellZscope " 20,00…
#>  9  1.3  CPE_A(sⁿ⁻¹·µF/cm²) A01    46.1 cellZscope         0 cellZscope " 80,00…
#> 10  1.3  CPE_A(sⁿ⁻¹·µF/cm²) A02    51.8 cellZscope         0 cellZscope " 80,00…
#> # ℹ 88,278 more rows

#' # ScioSpec
raw = system.file("extdata/instruments/ScioSpec", package = "vascr")
vascr_import("sciospec", raw, model, "ScioSpec")
#> Joining with `by = join_by(channel)`
#> Joining with `by = join_by(time)`
#> # A tibble: 16,160 × 11
#>    channel      Frequency Unit    Value Well  Instrument  Time Experiment Sample
#>    <chr>            <dbl> <chr>   <dbl> <chr> <chr>      <dbl> <chr>      <chr> 
#>  1 Channel: EC…      100. R      20261. D02   sciospec       0 ScioSpec   D02   
#>  2 Channel: EC…      100. I     -19551. D02   sciospec       0 ScioSpec   D02   
#>  3 Channel: EC…      110. R      18171. D02   sciospec       0 ScioSpec   D02   
#>  4 Channel: EC…      110. I     -15598. D02   sciospec       0 ScioSpec   D02   
#>  5 Channel: EC…      120. R      17839. D02   sciospec       0 ScioSpec   D02   
#>  6 Channel: EC…      120. I     -16083. D02   sciospec       0 ScioSpec   D02   
#>  7 Channel: EC…      132. R      17475. D02   sciospec       0 ScioSpec   D02   
#>  8 Channel: EC…      132. I     -14845. D02   sciospec       0 ScioSpec   D02   
#>  9 Channel: EC…      145. R      17380. D02   sciospec       0 ScioSpec   D02   
#> 10 Channel: EC…      145. I     -13290. D02   sciospec       0 ScioSpec   D02   
#> # ℹ 16,150 more rows
#> # ℹ 2 more variables: SampleID <dbl>, Excluded <chr>

# }
```
