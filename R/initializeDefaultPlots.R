initializeDefaultPlots <- function(level2) {
    xml_path <- system.file("extdata", "plot_xml", package = "S4Level2")
    all_xml <- dir(xml_path, full.names = TRUE)
    for (xml_path in all_xml) {
        level2 <- addCompletePlotFromXml(level2, xml_path = xml_path)
    }
    return(level2)
}