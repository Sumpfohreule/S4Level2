########################################################################################################################
testInitializeFromMultipleSingleStrings <- function() {
    string_a <- "Plot"
    string_b <- "SubPlot"
    string_c <- "Logger"
    .URI_Multi <-URI(string_a, string_b, string_c)

    combined_string <- paste(c(string_a, string_b, string_c), collapse = "/")
    .URI_Single <- URI(combined_string)
    RUnit::checkEquals(target = .URI_Single, current = .URI_Multi)
}

testInitializeFromSingleAndCombinedString <- function() {
    single_string <- "Plot"
    combi_string <- "SubPlot/Logger"
    .URI_Multi <- URI(single_string, combi_string)

    all_combined <- paste(c(single_string, combi_string), collapse = "/")
    .URI_Single <- URI(all_combined)
    RUnit::checkEquals(target = .URI_Single, current = .URI_Multi)
}

testInitializeWithTwoURIs <- function() {
    first_string = "Plot"
    second_string = "SubPlot"
    .FirstURI <- URI(first_string)
    .SecondURI <- URI(second_string)
    .CombinedFromURIs <- URI(.FirstURI, .SecondURI)

    single_string <- paste(c(first_string, second_string), collapse = "/")
    .SingleStringURI <- URI(single_string)

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
    .URI <- URI("Altensteig")
    RUnit::checkEquals("Altensteig", getPlotName(.URI))
}

testGetSubPlotName <- function() {
    .URI <- URI("Altensteig/Buche")
    RUnit::checkEquals("Buche", getSubPlotName(.URI))
}

testGetDataStructureName <- function() {
    .URI <- URI("Altensteig/Buche/ADLM")
    RUnit::checkEquals("ADLM", getDataStructureName(.URI))
}

testErrorForMissingSubPlot <- function() {
    .URI <- URI("Altensteig")
    RUnit::checkException({
            getSubPlot(.URI)
        }
    )
}

testErrorForMissingDataStructure <- function() {
    .URI <- URI("Altensteig/Buche")
    RUnit::checkException({
            getDataStructure(.URI)
        }
    )
}

testToString <- function() {
    uri_string <- "Hallo/Du/Wurst"
    .URI <- URI(uri_string)

    RUnit::checkEquals(uri_string, getURIString(.URI))
}

testToStringEmpty <- function() {
    uri_string_empty <- ""
    .URI <- URI(uri_string_empty)

    RUnit::checkEquals(uri_string_empty, getURIString(.URI))
}


