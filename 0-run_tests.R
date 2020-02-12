########################################################################################################################
devtools::load_all()

test_dir <- system.file("RUnitTests", package = "S4Level2")
full_test_suite <- RUnit::defineTestSuite("Full test suite", dirs = test_dir)
RUnit::isValidTestSuite(full_test_suite)
runit <- RUnit::runTestSuite(full_test_suite)
RUnit::printTextProtocol(runit)


