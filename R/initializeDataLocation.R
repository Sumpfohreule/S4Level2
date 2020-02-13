initializeDataLocation <- function(path) {
    if (!dir.exists(path)) {
        stop("Can't create data folder in not existing path: ", path)
    }

    structure_path <- file.path(path, "internal_structure")
    if (file.exists(file.path(structure_path, "Level2.rds"))) {
        stop("S4Level2 location has already been initialized before. 'resetDataLocation()' can be used to reset.")
    }

    dir.create(structure_path, showWarnings = FALSE)
    level2 <- Level2(structure_path)
    saveL2Object(level2)
}

# for(plot.init.file in dir("plot_setup_files", full.names = TRUE)) {
#     source(plot.init.file)
# }