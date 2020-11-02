########################################################################################################################
#' @include 0.0.0-Level2URI.R
setClass(Class = "ADLM", contains = "Logger")

setMethod("initialize", signature = "ADLM", definition = function(
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
})

########################################################################################################################
#' @include importRawLoggerFile.R
setMethod("importRawLoggerFile", signature = "ADLM", definition = function(.Object, path) {
    readADLM(path) %>%
        tidyr::pivot_longer(cols = !Datum, names_to = "variable") %>%
        arrange(variable, Datum)
})
