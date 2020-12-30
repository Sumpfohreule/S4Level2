test_that("Root folder is correctly initialized in an existing directory", {
    MyUtilities::.clear_tempdir()
    test_directory <- tempdir()

    initializeDataLocation(test_directory)

    expect_true(dir.exists(file.path(test_directory, "internal_structure")))
})

test_that("New data folder is created in existing directory", {
    MyUtilities::.clear_tempdir()
    test_directory <- file.path(tempdir(), "NewDataTopFolder")

    initializeDataLocation(test_directory)

    created_folders <- dir(test_directory)
    expect_equal(created_folders, "internal_structure")
})

test_that("Error is thrown if path to new to create folder does not exist", {
    MyUtilities::.clear_tempdir()
    not_exisiting_path <- file.path("g:", "is", "quite", "unrealistic")

    expect_error(initializeDataLocation(not_exisiting_path))
})

test_that("Error is thrown that folder was already initialized and should be reset if needed", {
    MyUtilities::.clear_tempdir()

    initializeDataLocation(tempdir())

    expect_error(initializeDataLocation(tempdir()),
                 "has already been initialized before")
})
