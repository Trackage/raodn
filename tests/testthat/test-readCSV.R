context("read CSV")

test_that("read works", {
  example("read_aodn_csv")
})

#test_that("url building works",
#          aodn_build_url(raster::extent(142, 143, -45, -46), time_range = Sys.Date() - c(0, 2))
#          )
