########################################################################################################################
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
setMethod("importRawLoggerFile", signature = "TinyTag", definition = function(.Object, path) {
        data <- readTinyTag(path)
        long.table <- melt(data, id.vars = "Datum")
        setkey(long.table, variable, Datum)
        return(long.table)
    }
)
