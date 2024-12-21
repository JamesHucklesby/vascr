

test_that("Samples work",
          {
            
            
            map_1 = tribble(~Row, ~Column, ~Sample,
                            "A", "1 2 3", "10 nM Treatment 1 + 1nm water",
                            "B", "1 2 3", "100 nM Treatment 1 + 1nm water",
                            "C", "4 5 6", "10 nM Treatment 2 + 1nm water",
                            "D", "1 2 3", "100 nM Treatment 2 + 1nm water")
            
            map_2 = tribble(~Well, ~Sample,
                            "A1 A2 A3", "10 nM Treatment 1 + 1nm water",
                            "B1 B2 B3", "100 nM Treatment 1 + 1nm water",
                            "C1 C2 C3", "10 nM Treatment 2 + 1nm water",
                            "C1 C2 C3", "100 nM Treatment 2 + 1nm water")
            
            map_3 = tribble(~Sample,
                            "10 nM Treatment 1 + 1nm water",
                            "100 nM Treatment 1 + 1nm water",
                            "10 nM Treatment 2 + 1nm water",
                            "100 nM Treatment 2 + 1nm water")
            
            map_4 = tribble(~SampleID, ~Row, ~Column, ~Sample,
                            1, "A", "1 2 3", "10 nM Treatment 1 + 1nm water",
                            2, "B", "1 2 3", "100 nM Treatment 1 + 1nm water",
                            3, "A", "1 2 3", "10 nM Treatment 2 + 1nm water", # Repeat line
                            4, "D", "1 2 3", "100 nM Treatment 2 + 1nm water")
            
            map_5 = tribble(~SampleID, ~Row, ~Column, ~Sample,
                            1, "A", "1 2 3", "10 nM Treatment 1 + 1nm water",
                            2, "B", "1 2 3", "100 nM Treatment 1 + 1nm water",
                            3, "C", "1 2 3", "10 nM Treatment 1 + 1nm water", # Repeat line
                            4, "D", "1 2 3", "100 nM Treatment 2 + 1nm water")
            
            map_6 = tribble(~SampleID, ~Row, ~Column, ~Sample,
                            1, "A", "1 2 3", "10 nM Treatment 1 + 1nm water",
                            2, "B", "1 2 3", "100 nM Treatment 1 + 1nm water",
                            3, "C", "4 5 6", "10 nM Treatment 2 + 1nm water",
                            4, "D", "1 2 3", "100 nM Treatment 2 + 1nm water")
            
            map_7 = tribble(~SampleID, ~Row, ~Column, ~Sample,
                            1, "A", "1 2 3", "10 nM Treatment 1 + 1nm water + 6nm Treatment 2",
                            2, "B", "1 2 3", "100 nM Treatment 1 + 1nm water",
                            3, "C", "4 5 6", "10 nM Treatment 2 + 1nm water",
                            4, "D", "1 2 3", "100 nM Treatment 2 + 1nm water")
            
            
            
            expect_snapshot(vascr_import_map(map_1))
            expect_snapshot(vascr_import_map(map_2))
            expect_snapshot_error(vascr_import_map(map_3))
            expect_snapshot(vascr_import_map(map_4))
            expect_snapshot(vascr_import_map(map_5))
            expect_snapshot(vascr_import_map(map_6))
            expect_snapshot(vascr_import_map(map_7))
            
            
            expect_snapshot(vascr_explode(growth.df))
            
            lookup = system.file('extdata/instruments/eciskey.csv', package = 'vascr')
            expect_snapshot(vascr_import_map(lookup))
            
          })
