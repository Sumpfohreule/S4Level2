########################################################################################################################
#' Test if given object ist of class "SubPlot"
#' 
#' @return a boolean value
#' 
is.SubPlot <- function(x) {
    is_plot <- class(x) == "SubPlot"
    return(is_plot)
}
