#' Finds new data files and updates the database
#'
#' This may take a while, especially if run for the first time.
#' Files are searched for within the setup plot locations.
#' @export
updateDatabase <- function() {
    loadL2Object() %>%
        updateFilePaths() %>%
        updateData() %>%
        saveL2Object()
}