initializePlotsFromXml <- function(level2, xml_parent_dir) {
    all_xml <- dir(xml_parent_dir, full.names = TRUE, pattern = "\\.xml$")
    local_dir <- getLocalDirectory(level2)
    for (xml_path in all_xml) {
        level2 <- addCompletePlotFromXml(level2, xml_path = xml_path)
        file.copy(from = xml_path, to = local_dir)

        plot_name <- stringr::str_match(xml_path, pattern = "(?<=\\/)[[:alnum:]]+(?=_setup.xml$)") %>%
            MyUtilities::toUpperByIndex(1)
        plot <- level2 %>%
            getObjectByURI(Level2URI(plot_name))
    }
    return(level2)
}
