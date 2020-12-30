#' Initializes location to use for data storage
#'
#' Enough storage space is needed at the provided location. An additional (local) package "MyUtilities" is installed if not existing
#'
#' @param data_path A path to the storage location. Attention: Because imported data is saved here the location needs to have enough storage space!
#' @export
#'
initializeDataLocation <- function(data_path) {
    parent_path <- dirname(data_path)
    if (!dir.exists(parent_path)) {
        stop("Can't create data folder in not existing path: ", parent_path)
    }

    pre_initialized_locations <- dir(data_path, pattern = "Level2.rds$", recursive = TRUE)
    if (length(pre_initialized_locations) == 0) {
        structure_path <- file.path(data_path, "internal_structure")
        dir.create(structure_path, showWarnings = FALSE)
        level2 <- Level2(structure_path)
        saveL2Object(level2)
    }
    connectToExistingDataLocation(data_path)
}
