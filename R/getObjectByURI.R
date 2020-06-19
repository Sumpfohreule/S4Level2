#' Returns a Level2 Object contained within and is specified by the URI
#'
#' @param .Object An object of type Level2, SubPlot, Plot or DataStructure
#' @param .level2_uri An Level2URI or string that is equivalent
#' @export
setGeneric("getObjectByURI", def = function(.Object, level2_uri) {
    standardGeneric("getObjectByURI")
})
