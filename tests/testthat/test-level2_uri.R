testthat::test_that("getPlotURI returns on PlotURI", {
    plot_uri <- Level2URI("plot")
    testthat::expect_equal(getPlotURI(plot_uri), plot_uri)
})

testthat::test_that("getSubPlotURI returns on SubPlotURI", {
    subplot_uri <- Level2URI("plot/subplot")
    testthat::expect_equal(getSubPlotURI(subplot_uri), subplot_uri)
})

testthat::test_that("getDataStructureURI returns on DataStructureURI", {
    ds_uri <- Level2URI("plot/subplot/ds")
    testthat::expect_equal(getDataStructureURI(ds_uri), ds_uri)
})

