context("Loading of top Level2 Project class")
clean_temp <- function() {
    temp_contents <- dir(tempdir(), full.names = TRUE)
    unlink(temp_contents, recursive = TRUE)
}

test_that("Level2 Object is correctly loaded from path", {
    clean_temp()
    initializeDataLocation(tempdir())

    level2_object <- loadL2Object(tempdir())
    expect_is(level2_object, "Level2")

    level2_sub_folder_object <- loadL2Object(file.path(tempdir(), "internal_structure"))
    expect_is(level2_sub_folder_object, "Level2")
})
