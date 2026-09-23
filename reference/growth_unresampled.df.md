# Vascr growth data which is not resampled

A dataset containing the growth curves of hCMEC/D3 cell lines seeded at
various densities. This is a subset of 'growth.df', without the final
stages of processing.

## Usage

``` r
growth_unresampled.df
```

## Format

A tibble with 346370 rows and 9 variables:

- Time:

  The time at which the measurement was taken (hours)

- Unit:

  The unit the measurement was taken in

- Well:

  The well in which the measurement was taken

- Value:

  The value of the measurement taken

- Frequency:

  The frequency at which data was collected

- Experiment:

  Name of the experiment

- Instrument:

  The instrument data was collected on

- SampleID:

  The numerical ID of the sample

- Sample:

  The name of the treatment applied to the dataset

## Source

Hucklesby 2020
