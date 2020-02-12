########################################################################################################################
#' Central function for initializing the SensorMappings table to make changes simple
#'
#' @return A data.table with empty columns 'patterns', 'replacements' and 'origin.date
#'
initializeSensorMappings <- function() {
    data.table(patterns = character(),
        replacements = character(),
        origin.date = MyUtilities::POSIXct())
}
