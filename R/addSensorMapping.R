########################################################################################################################
setGeneric("addSensorMapping", def = function(
        .Object,
        pattern,
        replacement,
        origin.date = as.POSIXct("1900-01-01", tz = "UTC"),
        .URI = Level2URI("")) {

        standardGeneric("addSensorMapping")
    }
)
