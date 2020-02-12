########################################################################################################################
.setUp <- function() {
    temp_folders <- file.path(tempdir(), c("folder_a", "folder_b", "folder_c"))
    for (folder in temp_folders) {
        dir.create(folder)
    }
}

.tearDown <- function() {
    unlink(dir(tempdir(), full.names = TRUE), recursive = TRUE)
}


########################################################################################################################
testCreateDirectoryStructure <- function() {
    plot_name = "TestPlot"
    sub_plot_name = "TestSubPlot"
    data_structure_type = "TinyTag"

    .URI = URI(file.path(plot_name, sub_plot_name, data_structure_type))

    .Level2 <- .initializeL2Object(.URI, tempdir())
    saveL2Object(.Level2)

    target_directory <- file.path(tempdir(), plot_name, sub_plot_name, data_structure_type)
    RUnit::checkTrue(dir.exists(target_directory))
}

testMultiSourcePathInitialization <- function() {
    multiple_folders <- list.dirs(tempdir())
    assertthat::assert_that(length(multiple_folders) > 1)

    .Data_Structure <- new("DataStructure",
        unique_name = "TestName",
        uri = URI(""),
        local_directory = tempdir(),
        paths = multiple_folders)
    RUnit::checkIdentical(multiple_folders, getSourcePaths(.Data_Structure))
}

testFilesForPathsError <- function() {
    RUnit::DEACTIVATED("Functionality not yet implemented!")
    test_file <- file.path(tempdir(), "testfile.txt")
    writeLines("Hallo", con = test_file)
    assertthat::assert_that(file.exists(test_file))

    folders_with_file <- list.files(tempdir(), full.names = TRUE)
    RUnit::checkException(new("DataStructure", unique_name = "TestName", paths = folders_with_file))
}

testInitializationNoneExistingSourcePath <- function() {
    RUnit::checkException(new("DataStructure", unique_name = "TestName", paths = "ax"))
}

testDontUseURIForDeeperNestedObjects <- function() {
    RUnit::DEACTIVATED("'testDontUseURIForDeeperNestedObjects' is not implemented yet")
}


########################################################################################################################
.initializeL2Object <- function(.URI, path) {
    .Level2 <- new("Level2", path)

    if (getURI_Depth(.URI) >= 1) {
        plot_name <- getPlotName(.URI)
        .Level2 <- createAndAddPlot(.Level2, plot_name = plot_name, corrected.aggregate.path = path)
    }

    if (getURI_Depth(.URI) >= 2) {
        sub_plot_name <- getSubPlotName(.URI)
        .Level2 <- createAndAddSubPlot(.Level2, sub_plot_name = sub_plot_name, .URI = .URI)
    }

    if (getURI_Depth(.URI) >= 3) {
        logger_type <- getDataStructureName(.URI)
        .Level2 <- createAndAddLogger(
            .Object = .Level2,
            logger_type = logger_type,
            source_paths = path,
            .URI = .URI)
    }
    return(.Level2)
}


