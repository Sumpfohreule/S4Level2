########################################################################################################################
setClass(Class = "Level2URI", slots = c(
    URI_Split = "character",
    Depth = "numeric"
))

#' Constructor for Level2URI
#' @param ... URI like path consisting of 0-3 strings (Plot, SubPlot, Logger)
#' @export
Level2URI <- function(...) {
    uri_elements <- list(...) %>%
        unlist() %>%
        purrr::walk(~ if(!(is.character(.x) || is.Level2URI(.x))) { stop("Some element is not of type character or Level2URI")}) %>%
        purrr::map(~ as.character(.x)) %>%
        purrr::map(~ stringr::str_split(.x, pattern = "/")) %>%
        unlist()
    if (length(uri_elements) > 3) {
        elements <- unlist(uri_elements)
        stop("Can't convert the following elements to a Level2URI as its length would be > 3\n", paste(elements, collapse = "/"))
    }
    .Object <- new("Level2URI")
    .Object@URI_Split <- uri_elements
    .Object@Depth <- length(uri_elements)
    .Object
}

#' @include getURI_Depth.R
setMethod("getURI_Depth", signature = "Level2URI", definition = function(.Object) {
    return(.Object@Depth)
})

#' @include getPlotName.R
setMethod("getPlotName", signature = "Level2URI", definition = function(.Object) {
    if (getURI_Depth(.Object) < 1) {
        stop("PlotName seems to be missing from this Level2URI")
    }
    return(.Object@URI_Split[1])
})

#' @include getSubPlotName.R
setMethod("getSubPlotName", signature = "Level2URI", definition = function(.Object) {
    if (getURI_Depth(.Object) < 2) {
        stop("SubPlotName seems to be missing from this Level2URI")
    }
    return(.Object@URI_Split[2])
})

#' @include getDataStructureName.R
setMethod("getDataStructureName", signature = "Level2URI", definition = function(.Object) {
    if (getURI_Depth(.Object) < 3) {
        stop("DataStructureName seems to be missing from this Level2URI")
    }
    return(.Object@URI_Split[3])
})

#' S3 Method for converting a Level2URI into a character string
#'
#' @param .Object An Object of type Level2URI
#' @export
as.character.Level2URI <- function(.Object) {
    uri_string <- paste(.Object@URI_Split, collapse = "/")
    return(uri_string)
}
