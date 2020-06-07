########################################################################################################################
testInitializeFromMultipleSingleStrings <- function() {
    string_a <- "Plot"
    string_b <- "SubPlot"
    string_c <- "Logger"
    .URI_Multi <- Level2URI(string_a, string_b, string_c)

    combined_string <- paste(c(string_a, string_b, string_c), collapse = "/")
    .URI_Single <- Level2URI(combined_string)
    RUnit::checkEquals(target = .URI_Single, current = .URI_Multi)
}

testInitializeFromSingleAndCombinedString <- function() {
    single_string <- "Plot"
    combi_string <- "SubPlot/Logger"
    .URI_Multi <- Level2URI(single_string, combi_string)

    all_combined <- paste(c(single_string, combi_string), collapse = "/")
    .URI_Single <- Level2URI(all_combined)
    RUnit::checkEquals(target = .URI_Single, current = .URI_Multi)
}

testInitializeWithTwoURIs <- function() {
    first_string = "Plot"
    second_string = "SubPlot"
    .FirstURI <- Level2URI(first_string)
    .SecondURI <- Level2URI(second_string)
    .CombinedFromURIs <- Level2URI(.FirstURI, .SecondURI)

    single_string <- paste(c(first_string, second_string), collapse = "/")
    .SingleStringURI <- Level2URI(single_string)

    RUnit::checkEquals(target = .SingleStringURI, current = .CombinedFromURIs)
}

testInitializeWithURIAndString <- function() {
    RUnit::DEACTIVATED("'testInitializeWithURIAndString' is not implemented yet")
}

testErrorIfInitializationNotStringOrURI <- function() {
    RUnit::DEACTIVATED("'testErrorIfInitializationNotStringOrURI' is not implemented yet")
}

testErrorOnEmptyURIParts <- function() {
	RUnit::DEACTIVATED("'testErrorOnEmptyURIParts' is not implemented yet")
}


testGetPlotName <- function() {
    .URI <- Level2URI("Altensteig")
    RUnit::checkEquals("Altensteig", getPlotName(.URI))
}

testGetSubPlotName <- function() {
    .URI <- Level2URI("Altensteig/Buche")
    RUnit::checkEquals("Buche", getSubPlotName(.URI))
}

testGetDataStructureName <- function() {
    .URI <- Level2URI("Altensteig/Buche/ADLM")
    RUnit::checkEquals("ADLM", getDataStructureName(.URI))
}

testErrorForMissingSubPlot <- function() {
    .URI <- Level2URI("Altensteig")
    RUnit::checkException({
            getObjectByURI(.URI)
        }
    )
}

testErrorForMissingDataStructure <- function() {
    .URI <- Level2URI("Altensteig/Buche")
    RUnit::checkException({
            getDataStructure(.URI)
        }
    )
}

testToString <- function() {
    uri_string <- "Hallo/Du/Wurst"
    .URI <- Level2URI(uri_string)

    RUnit::checkEquals(uri_string, as.character(.URI))
}

testToStringEmpty <- function() {
    uri_string_empty <- ""
    .URI <- Level2URI(uri_string_empty)

    RUnit::checkEquals(uri_string_empty, as.character(.URI))
}


