########################################################################################################################
testInitialSensorMapping <- function() {
    RUnit::checkIdentical(.returnEmptySensorMappingComparisonTable(), initializeSensorMappings())
}

testAddSensorMapping <- function() {
    .Data_Structure <- .getDefaultDataStructure()
    .Data_Structure <- addSensorMapping(.Data_Structure, "a1", "a2")
    .Data_Structure <- addSensorMapping(.Data_Structure, "b1", "b2")

    mapping_table <- getSensorMappings(.Data_Structure)
    is_data_table <- is.data.table(mapping_table)
    RUnit::checkTrue(is_data_table)

    has_two_items <- nrow(mapping_table) == 2
    RUnit::checkTrue(has_two_items)

    RUnit::checkIdentical(c("a1", "b1"), mapping_table[, patterns])
    RUnit::checkIdentical(c("a2", "b2"), mapping_table[, replacements])
}

testAddSensorMappingNullPattern <- function() {
    .Data_Structure <- .getDefaultDataStructure()
    RUnit::checkException(addSensorMapping(.Data_Structure, pattern = NULL, replacement = "a2"))
}

testAddSensorMappingNullReplacement <- function() {
    .Data_Structure <- .getDefaultDataStructure()
    RUnit::checkException(addSensorMapping(.Data_Structure, pattern = "a2", replacement = NULL))
}

testDontAddDuplicateMapping <- function() {
    .Data_Structure <- .getDefaultDataStructure()
    .Data_Structure <- addSensorMapping(.Data_Structure, "hallo", "tschuess")
    .Data_Structure <- addSensorMapping(.Data_Structure, "hallo", "tschuess")
    only_one_row_added <- nrow(getSensorMappings(.Data_Structure)) == 1
    RUnit::checkTrue(only_one_row_added)
}


########################################################################################################################
.getDefaultDataStructure <- function() {
    return(DataStructure(unique_name = "TestName",
            uri = Level2URI(""),
            local_directory = tempdir(),
            paths = tempdir()))
}

.returnEmptySensorMappingComparisonTable <- function() {
    empty_sensor_mapping_table <- data.table::data.table(
        patterns = character(),
        replacements = character(),
        origin.date = MyUtilities::POSIXct())
    return(empty_sensor_mapping_table)
}
