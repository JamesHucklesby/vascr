# export works

    Code
      vascr_export(small_growth)
    Output
      $`Rb 0`
      # A tibble: 2 x 3
         Time `35 000_cells + HCMEC D3_line` `35 000_cells + HCMEC D3_line`
        <dbl>                          <dbl>                          <dbl>
      1     5                              0                              0
      2    10                              0                              0
      
      $`R 1000`
      # A tibble: 2 x 3
         Time `35 000_cells + HCMEC D3_line` `35 000_cells + HCMEC D3_line`
        <dbl>                          <dbl>                          <dbl>
      1     5                           422.                           580.
      2    10                           486.                           612.
      
      $`R 16000`
      # A tibble: 2 x 3
         Time `35 000_cells + HCMEC D3_line` `35 000_cells + HCMEC D3_line`
        <dbl>                          <dbl>                          <dbl>
      1     5                           244.                           293.
      2    10                           266.                           319.
      
      $`R 2000`
      # A tibble: 2 x 3
         Time `35 000_cells + HCMEC D3_line` `35 000_cells + HCMEC D3_line`
        <dbl>                          <dbl>                          <dbl>
      1     5                           360.                           495.
      2    10                           417.                           530.
      
      $`R 250`
      # A tibble: 2 x 3
         Time `35 000_cells + HCMEC D3_line` `35 000_cells + HCMEC D3_line`
        <dbl>                          <dbl>                          <dbl>
      1     5                           687.                           873.
      2    10                           749.                           891.
      
      $`R 32000`
      # A tibble: 2 x 3
         Time `35 000_cells + HCMEC D3_line` `35 000_cells + HCMEC D3_line`
        <dbl>                          <dbl>                          <dbl>
      1     5                           228.                           259.
      2    10                           242.                           277.
      
      $`R 4000`
      # A tibble: 2 x 3
         Time `35 000_cells + HCMEC D3_line` `35 000_cells + HCMEC D3_line`
        <dbl>                          <dbl>                          <dbl>
      1     5                           309.                           414.
      2    10                           355.                           449.
      
      $`R 500`
      # A tibble: 2 x 3
         Time `35 000_cells + HCMEC D3_line` `35 000_cells + HCMEC D3_line`
        <dbl>                          <dbl>                          <dbl>
      1     5                           510.                           685.
      2    10                           575.                           712.
      
      $`R 64000`
      # A tibble: 2 x 3
         Time `35 000_cells + HCMEC D3_line` `35 000_cells + HCMEC D3_line`
        <dbl>                          <dbl>                          <dbl>
      1     5                           220.                           241.
      2    10                           229.                           253.
      
      $`R 8000`
      # A tibble: 2 x 3
         Time `35 000_cells + HCMEC D3_line` `35 000_cells + HCMEC D3_line`
        <dbl>                          <dbl>                          <dbl>
      1     5                           271.                           345.
      2    10                           304.                           377.
      

---

    Code
      readxl::read_xlsx(filepath)
    Message
      New names:
      * `35 000_cells + HCMEC D3_line` -> `35 000_cells + HCMEC D3_line...2`
      * `35 000_cells + HCMEC D3_line` -> `35 000_cells + HCMEC D3_line...3`
    Output
      # A tibble: 2 x 3
         Time `35 000_cells + HCMEC D3_line...2` `35 000_cells + HCMEC D3_line...3`
        <dbl>                              <dbl>                              <dbl>
      1     5                                  0                                  0
      2    10                                  0                                  0

