########################################################################################################################
setClass(Class = "DeltaT", contains = "Logger")

setMethod("initialize", signature = "DeltaT",
    definition = function(
        .Object,
        unique_name = class(.Object),
        uri,
        local_directory,
        paths,
        pattern = "\\.dat") {
        
        callNextMethod(
            .Object,
            unique_name = unique_name,
            uri = uri,
            local_directory = local_directory,
            paths = paths,
            pattern = pattern)
    }
)


########################################################################################################################
setMethod("importRawLoggerFile", signature = "DeltaT", definition = function(.Object, path) {
        data <- readDeltaT(path)
        data <- as.data.table(data)
        long.table <- melt(data, id.vars = "Datum")
        setkey(long.table, variable, Datum)
        return(long.table)
    }
)