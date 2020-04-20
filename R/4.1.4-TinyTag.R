########################################################################################################################
#' @include 0.0.0-Level2URI.R
setClass(Class = "TinyTag", contains = "Logger")

setMethod("initialize", signature = "TinyTag",
    definition = function(
        .Object,
        unique_name = class(.Object),
        uri,
        local_directory,
        paths,
        pattern = "\\.txt") {

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
setMethod("importRawLoggerFile", signature = "TinyTag", definition = function(.Object, path) {
        data <- readTinyTag(path)
        long.table <- data.table::melt(data, id.vars = "Datum")
        data.table::setkey(long.table, variable, Datum)
        return(long.table)
    }
)
