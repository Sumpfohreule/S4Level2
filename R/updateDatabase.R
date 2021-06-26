#' Finds new data files and updates the database
#'
#' This may take a while, especially if run for the first time.
#' Files are searched for within the setup plot locations.
#' @param plots Strings either containing plots to update or a wildcard '*' for all plots
#' @param sub_plots Strings either containing sub plots to update or a wildcard '*' for all sub plots
#' @export
updateDatabase <- function(plots = "*", sub_plots = "*") {
    l2_object <- loadL2Object()

    all_paths <- file.path(plots, rep(sub_plots, length(plots)), "*") %>%
        purrr::map(Level2URI) %>%
        purrr::map(~ expandURIPlaceholder(l2_object, .x)) %>%
        unlist()

    for (object_path in all_paths) {
        print(sprintf("Updating %s", as.character(object_path)))
        updated_paths <- getObjectByURI(l2_object, object_path) %>%
            updateFilePaths()
        updated_data <- updateData(updated_paths)
        l2_object <- replaceObjectByURI(l2_object, updated_data)
        saveL2Object(l2_object)
    }
}