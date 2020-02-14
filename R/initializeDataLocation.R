initializeDataLocation <- function(data_path) {
    parent_path <- dirname(data_path)
    if (!dir.exists(parent_path)) {
        stop("Can't create data folder in not existing path: ", parent_path)
    }

    structure_path <- file.path(data_path, "internal_structure")
    pre_initialized_locations <- dir(data_path, pattern = "Level2.rds$", recursive = TRUE)
    if (length(pre_initialized_locations) > 0) {
        stop("S4Level2 location has already been initialized before. 'resetDataLocation()' can be used to reset.")
    }

    dir.create(structure_path, showWarnings = FALSE, recursive = TRUE)
    level2 <- Level2(structure_path)
    saveL2Object(level2)
}
