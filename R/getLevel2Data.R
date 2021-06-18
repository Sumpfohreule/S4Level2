#' Retrive data imported by S4Level2 package
#'
#' @param plot_URIs String vector (Optional) with which to select Plots, SubPlots and Loggers.
#'
#' @param start_date Date (Optional) from where to begin retrieving data (inclusive)
#' @param end_date Date (Optional) from where to begin retrieving data (exclusive)
#' @details \code{plot_URIs} can be written similar to a folder path with the basic structure: "plot/sub_plot/logger"
#' If a logger or sub_plot is left out every
#' "." equals everything
#' "Altensteig" = Data for all sub plots and loggers of Altensteig
#' "*/
#'
getLevel2Data <- function(
    plot_URIs = c("."),
    start_date = "1900-01-01",
    end_date = "2100-01-01") {

    if (length(plot_URIs) == 1 && plot_URIs == ".") {
        plot_URIs <- getChildURIs(loadL2Object())
    }

    plot_URIs %>%
        purrr::map(~ Level2URI(.x)) %>%
        purrr::map(~ getObjectByURI(loadL2Object(), .x)) %>%
        purrr::map(~ getLoggerData(.x, start_date, end_date)) %>%
        bind_rows()
}
