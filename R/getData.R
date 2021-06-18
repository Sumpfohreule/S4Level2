#' Retrieves data which was aggregated with the S4Level2 package
#'
#' @param start_date A string or (Time-)Date from where data retrieval should start (inclusive)
#' @param end_date A string or (Time-)Date at which data retrieval should end (exclusive)
#' @param plot A string which must match the name of a Level2 plot
#' @param sub_plot A string (Optional) which can be used to further restrict retrieval
#' to a specific sub_plot of the given plot
#' @details If the dates are provided as a strings it works best if the following
#' format is followed: "yyyy-mm-dd hh:mm:ss"
#' @export
getData <- function(
    start_date,
    end_date,
    plot,
    sub_plot = "*") {
    assertthat::assert_that(assertthat::is.string(plot))
    assertthat::assert_that(assertthat::is.string(sub_plot))
    Level2URI(plot_name, sub_plot_name, "*") %>%
        expandURIPlaceholder(loadL2Object(), .) %>%
        purrr::map(~ getObjectByURI(loadL2Object(), .x)) %>%
        purrr::map(~ getLoggerData(.x, start_date, end_date)) %>%
        bind_rows()
}