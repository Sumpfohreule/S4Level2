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

test_that("getPlotName returns empty string if not contained", {
    expect_equal(getPlotName(Level2URI()), "")
})

test_that("getSubPlotName returns empty string if not contained", {
    expect_equal(getSubPlotName(Level2URI()), "")
})

test_that("getDataStructureName returns empty string if not contained", {
    expect_equal(getDataStructureName(Level2URI()), "")
})

test_that("An empty element is ignored if it is at logger level", {
    expect_equal(Level2URI("x", "y", ""), Level2URI("x", "y"))
})