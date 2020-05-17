.initializeL2Object <- function(.URI, path) {
    .Level2 <- Level2(path)

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


########################################################################################################################
testGetLocalDirectory <- function() {
    plot_name <- "TestPlot"
    .Plot_URI <- Level2URI(plot_name)
    .Level2 <- .initializeL2Object(.Plot_URI, tempdir())

    .Test_Plot <- getPlotList(.Level2)[[plot_name]]
    target_directory <- file.path(tempdir(), plot_name)
    RUnit::checkEquals(target_directory, getLocalDirectory(.Test_Plot))
}

testGetURI <- function() {
    plot_name = "TestPlot"
    .URI <- Level2URI(file.path(plot_name))
    .Level2 <- .initializeL2Object(.URI, tempdir())

    .Test_Plot <- getPlot(.Level2, .URI)
    RUnit::checkEquals(.URI, getURI(.Test_Plot))
}

testDontUseURIForDeeperNestedObjects <- function() {
	RUnit::DEACTIVATED("'testDontUseURIForDeeperNestedObjects' is not implemented yet")
}


testCreateDirectoryStructure <- function() {
    plot_name <- "TestPlot"
    .Plot_URI <- Level2URI(plot_name)
    test_directory <- file.path(tempdir(), plot_name)
    .Level2 <- .initializeL2Object(.Plot_URI, tempdir())
    saveL2Object(.Level2)

    RUnit::checkTrue(dir.exists(test_directory))
}

testCreateAndAddMultipleSubPlots <- function() {
    plot_name <- "TestPlot"
    .URI <- Level2URI(plot_name)

    .Plot <- Plot(name = plot_name,
                  local_directory = tempdir(),
                  corrected.aggregate.path = tempdir())

    sub_plot_names <- c("Buche", "Fichte", "Freiland")
    .Plot <- createAndAddMultipleSubPlots(.Plot, sub_plot_names)

    sub_plot_list <- .SubPlotList <- getSubPlotList(.Plot)
    RUnit::checkEquals(3, length(sub_plot_list))
	RUnit::checkEquals(sub_plot_names, names(sub_plot_list))
}


testReplaceListObject <- function() {
    plot_name <- "TestPlot"
    sub_plot_name <- "TestSubPlot"
    .Plot_URI <- Level2URI(file.path(plot_name, sub_plot_name))
    .Level2 <- .initializeL2Object(.URI = .Plot_URI, path = tempdir())

    .TestPlot <- getPlotList(.Level2)[[plot_name]]
    .Replacement_SubPlot <- new("SubPlot",
        name = sub_plot_name,
        uri = Level2URI("PlotName/SubPlotName"),
        local_directory = "c:/")
    .TestPlot <- replaceListObject(.TestPlot, .Replacement_SubPlot)

    RUnit::checkEquals(.Replacement_SubPlot, getSubPlotList(.TestPlot)[[sub_plot_name]])
}

testReplaceSubPlotByURI <- function() {
    plot_name = "TestPlot"
    sub_plot_name = "TestSubPlot"
    .URI <- Level2URI(file.path(plot_name, sub_plot_name))
    .Level2 <- .initializeL2Object(.URI, tempdir())

    .ReplacementSubPlot <- new("SubPlot",
        name = sub_plot_name,
        uri = .URI,
        local_directory = file.path(tempdir(), "somewhere_else"))

    .TestPlot <- getPlot(.Level2, .URI)
    .TestPlot <- replaceObjectByURI(.TestPlot, .ReplacementSubPlot)

    sub_plot_list <- getSubPlotList(.TestPlot)
    RUnit::checkEquals(1, length(sub_plot_list))

    .ReplacedSubPlot <- getSubPlot(.TestPlot, .URI)
    RUnit::checkEquals(.ReplacementSubPlot, .ReplacedSubPlot)
}


