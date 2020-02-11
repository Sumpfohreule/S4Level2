########################################################################################################################
setClass(Class = "ADLM", contains = "Logger")

setMethod("initialize", signature = "ADLM",
    definition = function(
        .Object,
        unique_name = class(.Object),
        uri,
        local_directory,
        paths,
        pattern = "^[^~]((?!ed).)*\\.xlsx$") {
        
        callNextMethod(.Object,
            unique_name = unique_name,
            uri = uri,
            local_directory = local_directory,
            paths = paths,
            pattern = pattern)
    }
)


########################################################################################################################
setMethod("importRawLoggerFile", signature = "ADLM", definition = function(.Object, path) {
        data <- readADLM(path)
        long.table <- melt(data, id.vars = "Datum")
        setkey(long.table, variable, Datum)
        return(long.table)
    }
)
