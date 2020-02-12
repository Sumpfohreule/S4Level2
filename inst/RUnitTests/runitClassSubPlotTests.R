########################################################################################################################
testDontUseURIForDeeperNestedObjects <- function() {
    RUnit::DEACTIVATED("'testDontUseURIForDeeperNestedObjects' is not implemented yet")
}

testCreateDirectoryStructure <- function() {
	plot_name = "TestPlot"
    sub_plot_name = "TestSubPlot"
    .URI = new("URI", file.path(plot_name, sub_plot_name))
    
    .Level2 <- .initializeL2Object(.URI, tempdir())
    saveL2Object(.Level2)
    
    target_directory <- file.path(tempdir(), plot_name, sub_plot_name)
    RUnit::checkTrue(dir.exists(target_directory))
}

testReplaceSubPlotByURI <- function() {
    plot_name = "TestPlot"
    sub_plot_name = "TestSubPlot"
    data_structure_type = "ADLM"
    
    .URI <- new("URI", file.path(plot_name, sub_plot_name, data_structure_type))
    .Level2 <- .initializeL2Object(.URI, tempdir())
    
    .ReplacementDataStructure <- new(data_structure_type,
        uri = .URI,
        local_directory = file.path(tempdir(), "somewhere_else"),
        paths = tempdir())
    
    .TestSubPlot <- getSubPlot(.Level2, .URI)
    .TestSubPlot <- replaceObjectByURI(.TestSubPlot, .ReplacementDataStructure)
    
    data_structure_list <- getDataStructureList(.TestSubPlot)
    RUnit::checkEquals(1, length(data_structure_list))
    
    .ReplacedDataStructure <- getDataStructure(.TestSubPlot, .URI)
    RUnit::checkEquals(.ReplacementDataStructure, .ReplacedDataStructure)
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