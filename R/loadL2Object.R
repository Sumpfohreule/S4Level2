########################################################################################################################
#' Load the top level Level2 Object
#' @param data_path A string with the path to the package top level data location
#' @return An Object of class Level2
loadL2Object <- function() {
    data_path <- readRDS("data/output/data_location_path.rds")
    level2_file <- dir(data_path, pattern = "Level2.rds$", full.names = TRUE, recursive = TRUE)
    tryCatch(.Object <- readRDS(file = level2_file),
             error = function(e) {
                 stop("Data directory does not seem to be initialized.\n",
                      "Change data_path or use initializeDataLocation function")
             }
    )
    return(.Object)
}
