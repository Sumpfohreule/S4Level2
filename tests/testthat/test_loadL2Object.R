context("Loading of top Level2 Project class")

test_that("Level2 Object is correctly loaded from path", {
    MyUtilities::.clear_tempdir()
    initializeDataLocation(tempdir())

    level2_object <- loadL2Object(tempdir())
    expect_is(level2_object, "Level2")

    level2_sub_folder_object <- loadL2Object(file.path(tempdir(), "internal_structure"))
    expect_is(level2_sub_folder_object, "Level2")
})
