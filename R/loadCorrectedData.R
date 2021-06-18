#' Load the data of corrected files from predefined folders of this plot
#' @param plot_name String with the name of the plot to retrieve the data for
#' @param sheet_names String vector to determine which kind of SubPlot should be loaded from each file
#' @param years Numeric vector of years to load from the plot corrected files
#' @return A data.table with all the data combined
#' @export
loadCorrectedData <- function(plot_name, sheet_names, years = NULL) {
    full_data <- loadL2Object() %>%
        getObjectByURI(plot_name) %>%
        getCorrectedAggregatePath() %>%
        dir(full.names = TRUE) %>%
        purrr::keep(~ is.null(years) || (TRUE %in% (basename(.x) %in% as.character(years)))) %>%
        purrr::map(~ {
            path <- .x
            sheet_names %>%
                purrr::map(~ c(path, .x))
        }) %>%
        purrr::flatten() %>%
        purrr::map(~ {
            tryCatch({
                path <- .x[1]
                sheet <- .x[2]
                wide_import <- MyUtilities::getLastModifiedFile(
                    folder = path,
                    pattern = "\\.xlsx$",
                    recursive = TRUE) %>%
                    MyUtilities::importAggregateExcelSheet(sheet)
                wide_import %>%
                    data.table::setnames(make.unique(names(wide_import))) %>%
                    tidyr::pivot_longer(cols = -Datum, names_to = "variable") %>%
                    mutate(SubPlot = sheet)
            }, error = function(e) {
                if (stringr::str_detect(as.character(e), "Values from 'sheet' are not contained in")) {
                    cat("Skipped file '", basename(.x), "' for sheet '", sheet_names, "' as it was missing.\n", sep = "")
                } else {
                    stop(e)
                }
            })
        }) %>%
        bind_rows() %>%
        mutate_at(vars(SubPlot), as.factor) %>%
        arrange(SubPlot, variable, Datum) %>%
        select(SubPlot, Datum, variable, value)
    return(full_data)
}
