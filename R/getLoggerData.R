########################################################################################################################
setGeneric("getLoggerData", def = function(
        .Object,
        start.date = "1900-01-01",
        end.date = "2100-01-01",
        plot = NULL,
        sub.plot = NULL,
        logger.name = NULL,
        as.wide.table = FALSE) {
        standardGeneric("getLoggerData")
})
