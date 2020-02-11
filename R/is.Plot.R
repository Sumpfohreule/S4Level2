########################################################################################################################
#' Test if given object ist of class "Plot"
#' 
#' @return a boolean value
#' 
is.Plot <- function(x) {
	is_plot <- class(x) == "Plot"
    return(is_plot)
}
