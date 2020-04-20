initializeDefaultPlots <- function(level2) {
    xml_path <- system.file("extdata", "plot_xml", package = "S4Level2")
    level2 <- initializePlotsFromXml(level2, xml_path)
    return(level2)
}
