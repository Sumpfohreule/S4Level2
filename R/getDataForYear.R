#' Retrieve data from the S4Level2 data for a selected year
#'
#' @param target_year Numeric value representing a year to retrieve data for
#' @param plot_URIs String (Optional) of a plot name, for which to retrieve data for
#' @export
getDataForYear <- function(target_year, plot_URIs) {
    as.Level2URI(plot_URIs) %>%
        purrr::map(~ expandURIPlaceholder(loadL2Object(), .x)) %>%
        purrr::flatten() %>%
        purrr::map(~ {
            loadL2Object() %>%
                getObjectByURI(.x)
        }) %>%
        purrr::map(~ getLoggerData(.x, start.date = paste0(target_year - 1, "-12-01"), end.date = paste0(target_year + 1, "-02-01"))) %>%
        bind_rows() %>%
        filter(lubridate::year(Datum) == target_year)
}
