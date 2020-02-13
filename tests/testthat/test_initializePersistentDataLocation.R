context("Initialization of S4Level2 Project structure")
clean_temp <- function() {
    temp_contents <- dir(tempdir(), full.names = TRUE)
    unlink(temp_contents, recursive = TRUE)
}

test_that("Folders are corectly initialized in an existing directory", {
    clean_temp()
    test_dir <- tempdir()

    initializeDataLocation(test_dir)

    created_folders <- dir(test_dir)
    expect_equal(created_folders, "internal_structure")
})

test_that("Error is thrown if base folder does not exist", {
    clean_temp()
    not_exisiting_path <- file.path("g:", "is", "quite", "unrealistic")

    expect_error(initializeDataLocation(not_exisiting_path))
})

test_that("Error is thrown that folder was already initialized and should be reset if needed", {
    clean_temp()

    initializeDataLocation(tempdir())

    expect_error(initializeDataLocation(tempdir()),
                 "has already been initialized before")
})