########################################################################################################################
setClass(Class = "Level2URI", slots = c(
        URI_Split = "character",
        Depth = "numeric"
    )
)

#' Constructor for Level2URI
#' @param ... URI like path consisting of 0-3 strings (Plot, SubPlot, Logger)
#' @export
Level2URI <- function(...) {
    elipsis_elements <- list(...)
    for (index in 1:length(elipsis_elements)) {
        element <- elipsis_elements[[index]]

        is_character <- is.character(element)
        is_uri <- is.Level2URI(element)
        if (!(is_character || is_uri)) {
            stop("Element to be passed to URI needs to be of character or Level2URI class")
        }

        elipsis_elements[[index]] <- ifelse(
            test = is.Level2URI(element),
            yes = getURIString(element),
            no = as.character(element))
    }
    uri_string <- paste(unlist(elipsis_elements), collapse = "/")
    # TODO: check for double //
    uri_split <- strsplit(uri_string, "/")[[1]]
    depth = length(uri_split)
    assertthat::assert_that(depth <= 3)

    .Object <- new("Level2URI")
    .Object@URI_Split <- uri_split
    .Object@Depth <- depth
    .Object
}

#' @include getURI_Depth.R
setMethod("getURI_Depth", signature = "Level2URI", definition = function(.Object) {
		return(.Object@Depth)
    }
)

#' @include getPlotName.R
setMethod("getPlotName", signature = "Level2URI", definition = function(.Object) {
        if (getURI_Depth(.Object) < 1) {
            stop("PlotName seems to be missing from this Level2URI")
        }
		return(.Object@URI_Split[1])
    }
)

#' @include getSubPlotName.R
setMethod("getSubPlotName", signature = "Level2URI", definition = function(.Object) {
        if (getURI_Depth(.Object) < 2) {
            stop("SubPlotName seems to be missing from this Level2URI")
        }
        return(.Object@URI_Split[2])
    }
)

#' @include getDataStructureName.R
setMethod("getDataStructureName", signature = "Level2URI", definition = function(.Object) {
        if (getURI_Depth(.Object) < 3) {
            stop("DataStructureName seems to be missing from this Level2URI")
        }
        return(.Object@URI_Split[3])
    }
)

#' @include getURIString.R
setMethod("getURIString", signature = "Level2URI", definition = function(.Object) {
		uri_string <- paste(.Object@URI_Split, collapse = "/")
        return(uri_string)
    }
)
