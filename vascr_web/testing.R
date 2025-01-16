
library(shinytest2)

record_test("vascr_web/")

test_app("vascr_web/")

snapshot_review(path = "vascr_web/tests/testthat")
