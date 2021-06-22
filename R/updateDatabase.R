#' Finds new data files and updates the database
#'
#' This may take a while, especially if run for the first time.
#' Files are searched for within the setup plot locations.
#' @export
updateDatabase <- function() {
    for (path in expandURIPlaceholder(loadL2Object(), Level2URI("*/*/*"))) {
        updated_paths <- getObjectByURI(loadL2Object(), path) %>%
            updateFilePaths()
        updated_data <- updateData(updated_paths)
        updated_l2 <- replaceObjectByURI(loadL2Object(), updated_data)
        saveL2Object(updated_l2)
    }
}