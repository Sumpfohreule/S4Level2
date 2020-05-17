resetDataLocation <- function(path) {
    if ("internal_structure" %in% dir(path) && "Level2.rds" %in% dir(file.path(path, "internal_structure"))) {
        unlink(file.path(path, "internal_structure"), recursive = TRUE)
        initializeDataLocation(path)
    } else {
        stop("Location does not contain 'internal_structure/Level2.rds'")
    }
}