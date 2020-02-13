########################################################################################################################
#' @include URI.R
setClass(Class = "Envilog", contains = "Logger")

setMethod("initialize", signature = "Envilog",
    definition = function(
        .Object,
        unique_name = class(.Object),
        uri,
        local_directory,
        paths,
        pattern = "\\.csv") {

        callNextMethod(.Object,
            unique_name = unique_name,
            uri = uri,
            local_directory = local_directory,
            paths = paths,
            pattern = pattern)
    }
)


########################################################################################################################
#' @include importRawLoggerFile.R
setMethod("importRawLoggerFile", signature = "Envilog", definition = function(.Object, path) {
        data <- readEnvilog(path)
        long.table <- data.table::melt(data, id.vars = "Datum")
        data.table::setkey(long.table, variable, Datum)
        return(long.table)
    }
)