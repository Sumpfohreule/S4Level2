#' Connect to an existing Level2 data location
#'
#' Can be used to establish a permanent connection to an already created data location.
#' A folder (data/output) is created within the current work directory and the path is saved there for internal use of the package.
#' @param data_path A string with the location of the existing data location
#' @export
connectToExistingDataLocation <- function(data_path) {
    if (!dir.exists(data_path)) {
        stop("Given path does not exists!")
    }
    if (length(dir(data_path, pattern = "^Level2\\.rds$", recursive = TRUE)) == 0) {
        stop("Given path does not seem to be initialized. Use initializeDataLocation instead")
    }
    dir.create("data/output", recursive = TRUE, showWarnings = FALSE)
    saveRDS(data_path, "data/output/data_location_path.rds")

    is_MyUtilities_missing <- installed.packages() %>%
        data.frame() %>%
        filter(Package == "MyUtilities") %>%
        ( function(x) { nrow(x) == 0 } )
    if (is_MyUtilities_missing) {
        install.packages(
            system.file("extdata", "MyUtilities_4.1.1.tar.gz", package = "S4Level2"),
            repos = NULL)
    }

}