########################################################################################################################
loadL2Object <- function() {
    data_path <- readRDS(DATA_PATH_FILE_LOCATION)
    level2_file <- dir(data_path, pattern = "Level2.rds$", full.names = TRUE, recursive = TRUE)
    tryCatch(.Object <- readRDS(file = level2_file),
             error = function(e) {
                 stop("Data directory does not seem to be initialized.\n",
                      "Either connect to an existing Level2-Location (S4Level2::connectToExistingDataLocation)\n",
                      "or create a new one (S4Level2::initializeDataLocation)")
             }
    )
    return(.Object)
}
