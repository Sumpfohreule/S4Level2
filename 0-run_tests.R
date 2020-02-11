########################################################################################################################
setwd("O:/TRANSP/IsenbergLars/Projekte/S4Level2")
rm(list = ls(all.names = TRUE))
source("init.R")


########################################################################################################################
full_test_suite <- RUnit::defineTestSuite("Full test suite", dirs = "RUnitTests")
RUnit::isValidTestSuite(full_test_suite)
runit <- RUnit::runTestSuite(full_test_suite)
RUnit::printTextProtocol(runit)


