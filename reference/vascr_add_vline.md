# Add a vertical line to a vascr line plot

Add a vertical line to a vascr line plot

## Usage

``` r
vascr_add_vline(plot, times.df)
```

## Arguments

- plot:

  The vascr plot to receive a vertical line (or lines)

- times.df:

  A tibble containing "time", "color" and "label" columns to specify the
  addition of lines

## Value

A labeled vascr plot

## Examples

``` r
plot1_data = growth.df %>% vascr_subset(unit = "R", frequency = "4000")
plot1 = plot1_data %>% vascr_summarise("summary") %>% vascr_plot_line()

times.df = tribble(~time, ~label, ~colour, 100, "Test Point", "orange")
vascr_add_vline(plot1, times.df)


times.df = tribble(~time, ~label, 100, "ZTest Point", 150, "Test Point 2")
vascr_add_vline(plot1, times.df)

```
