initializePlotsFromXml <- function(level1, xml_parent_dir) {
    all_xml <- dir(xml_parent_dir, full.names = TRUE, pattern = "\\.xml$")
    for (xml_path in all_xml) {
        level2 <- addCompletePlotFromXml(level2, xml_path = xml_path)

        plot_name <- stringr::str_match(xml_path, pattern = "(?<=\\/)[[:alnum:]]+(?=_setup.xml$)") %>%
            MyUtilities::toUpperByIndex(1)
        plot <- level2 %>%
            getPlot(Level2URI(plot_name))
        local_dir <- plot %>%
            getLocalDirectory()
        file.copy(from = xml_path, to = local_dir)

        output_dir <- plot %>%
            getOutputDirectory()
        dir.create(output_dir, showWarnings = FALSE)
    }
    return(level2)
}