context("Initialization of S4Level2 Project structure")
clean_temp <- function() {
    temp_contents <- dir(tempdir(), full.names = TRUE)
    unlink(temp_contents, recursive = TRUE)
}

test_that("Root folder is correctly initialized in an existing directory", {
    clean_temp()
    test_directory <- tempdir()

    initializeDataLocation(test_directory)

    expect_true(dir.exists(file.path(test_directory, "internal_structure")))
})

test_that("New data folder is created in existing directory", {
    clean_temp()
    test_directory <- file.path(tempdir(), "NewDataTopFolder")

    initializeDataLocation(test_directory)

    created_folders <- dir(test_directory)
    expect_equal(created_folders, "internal_structure")
})

test_that("Error is thrown if path to new to create folder does not exist", {
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
