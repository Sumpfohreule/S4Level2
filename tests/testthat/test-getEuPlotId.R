test_that("Functions works in vectorized form", {
    testthat::skip("Integrate tests for getEuPlotId")
})

test_that("Works with single plot and subplot", {
    testthat::expect_equal(getEuPlotId("Altensteig", "Fichte"), 819)
    testthat::expect_equal(getEuPlotId("Ochsenhausen", "Buche"), 858)
})

test_that("Helpfull error message for missing plot", {
    testthat::expect_error(getEuPlotId("Entenhausen", "Fichte"), "Für den anggegebene Plot 'Entenhausen' existieren keine Eu Ids")
})

test_that("Helpfull error message for missing sheet", {
    testthat::expect_error(getEuPlotId("Altensteig", "Betonwueste"), "Für den anggegebene SubPlot 'Betonwueste' existieren keine Eu Ids")
})

test_that("Helpfull error message if plot does not have the sheet", {
    testthat::expect_error(getEuPlotId("Rotenfels", "Buche"), "Plot 'Rotenfels' hat keien Eu Id für den SubPlot 'Buche'")
})