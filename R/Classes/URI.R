########################################################################################################################
setClass(Class = "URI", slots = c(
        URI_Split = "character",
        Depth = "numeric"
    )
)

setMethod("initialize", signature = "URI", definition = function(.Object, ...) {
        elipsis_elements <- list(...)
        for (index in 1:length(elipsis_elements)) {
            element <- elipsis_elements[[index]]
            
            is_character <- is.character(element)
            is_uri <- is.URI(element)
            if (!(is_character || is_uri)) {
                stop("Element to be passed to URI needs to be of character or URI class")
            }
            
            elipsis_elements[[index]] <- ifelse(
                test = is.URI(element),
                yes = getURIString(element),
                no = as.character(element))
        }
        uri_string <- paste(unlist(elipsis_elements), collapse = "/")
        # TODO: check for double //
		uri_split <- strsplit(uri_string, "/")[[1]]
        depth = length(uri_split)
        assertthat::assert_that(depth <= 3)
        
        .Object@URI_Split <- uri_split
        .Object@Depth <- depth
        .Object
    }
)

setMethod("getURI_Depth", signature = "URI", definition = function(.Object) {
		return(.Object@Depth)
    }
)

setMethod("getPlotName", signature = "URI", definition = function(.Object) {
        if (getURI_Depth(.Object) < 1) {
            stop("PlotName seems to be missing from this URI")
        }
		return(.Object@URI_Split[1])
    }
)

setMethod("getSubPlotName", signature = "URI", definition = function(.Object) {
        if (getURI_Depth(.Object) < 2) {
            stop("SubPlotName seems to be missing from this URI")
        }
        return(.Object@URI_Split[2])
    }
)

setMethod("getDataStructureName", signature = "URI", definition = function(.Object) {
        if (getURI_Depth(.Object) < 3) {
            stop("DataStructureName seems to be missing from this URI")
        }
        return(.Object@URI_Split[3])
    }
)

setMethod("getURIString", signature = "URI", definition = function(.Object) {
		uri_string <- paste(.Object@URI_Split, collapse = "/")
        return(uri_string)
    }
)
