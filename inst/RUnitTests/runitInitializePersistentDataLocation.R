testFoldersInitialized <- function() {
    test_dir <- tempdir()

    initializePersistentDataLocation(test_dir)

    created_folders <- dir(test_dir)
    RUnit::checkEquals(target = c("internal_structure"))
}