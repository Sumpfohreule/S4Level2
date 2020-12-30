########################################################################################################################
#' Load the top level Level2 Object
#' @return An Object of class Level2
loadL2Object <- function() {
    data_path <- readRDS(DATA_PATH_FILE_LOCATION)
    level2_file <- dir(data_path, pattern = "Level2.rds$", full.names = TRUE, recursive = TRUE)
    tryCatch(.Object <- readRDS(file = level2_file),
             error = function(e) {
                 stop("Data directory does not seem to be initialized.\n",
                      "Change data_path or use initializeDataLocation function")
             }
    )
    return(.Object)
}
