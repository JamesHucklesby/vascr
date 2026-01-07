# Launch the vascr UI

Launch the vascr UI

## Usage

``` r
vascr_shiny(data.df)
```

## Arguments

- data.df:

  Data to preload into shiny app

## Value

A shinyApp to work with vascr data

## Examples

``` r
 if(interactive()){
   vascr_shiny()
 }
```
