#' Finds new data files and updates the database
#'
#' This may take a while, especially if run for the first time.
#' Files are searched for within the setup plot locations.
#' @export
updateDatabase <- function() {
    l2_object <- loadL2Object()
    for (path in expandURIPlaceholder(l2_object, Level2URI("*/*/*"))) {
        updated_paths <- getObjectByURI(l2_object, path) %>%
            updateFilePaths()
        updated_data <- updateData(updated_paths)
        updated_l2 <- replaceObjectByURI(l2_object, updated_data)
        saveL2Object(updated_l2)
    }
}