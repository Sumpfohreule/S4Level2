addPlotWithLoggersFromXML <- function(level2, xml_path) {
    xml_root <- xml2::read_xml(xml_path)

    plot_name <- xml2::xml_attr(xml_root, attr = "name")
    screened_data_path <- xml2::xml_attr(xml_root, attr = "screened_data_path")

    level2 <- createAndAddPlot(level2, plot_name, screened_data_path)

    logger_nodes <- xml2::xml_children(xml_root)

    for (logger_node in logger_nodes) {
        # Create SubPlot if needed
        sub_plot_name <- xml2::xml_attr(logger_node, "sub_plot")
        sub_plot_uri <- Level2URI(plot_name, sub_plot_name)
        level2 <- createAndAddSubPlot(level2, sub_plot_name, sub_plot_uri)

        # Create and add Logger
        logger_type <- xml2::xml_attr(logger_node, "type")
        source_paths <- xml2::xml_find_all(logger_node, "Source_Path") %>%
            xml2::xml_attr("path")
        logger_uri <- Level2URI(sub_plot_uri, logger_type)

        level2 <- createAndAddLogger(level2,
                                     logger_type = logger_type,
                                     source_paths = source_paths,
                                     .URI = logger_uri)

        # Add Sensor Mappings
        mapping_table <- xml_readMappings(logger_node)
        for (mapping_index in 1:nrow(mapping_table)) {
            pattern <- mapping_table[mapping_index, "patterns"]
            replacement <- mapping_table[mapping_index, "replacements"]
            origin_date <- mapping_table[mapping_index, "origin_dates"]
            level2 <- addSensorMapping(level2,
                                       pattern,
                                       replacement,
                                       .URI = logger_uri)
        }
    }
    return(level2)
}

xml_readMappings <- function(xml_node) {
    x_path <- paste0("Mapping")
    patterns <- xml_node %>%
        xml2::xml_find_all(x_path) %>%
        xml2::xml_attr("pattern")
    replacements <- xml_node %>%
        xml2::xml_find_all(x_path) %>%
        xml2::xml_attr("replacement")
    origin_dates <- xml_node %>%
        xml2::xml_find_all(x_path) %>%
        xml2::xml_attr("origin_date")

    mapping_table <- data.frame(patterns, replacements, origin_dates) %>%
        mutate_all(as.character)
    return(mapping_table)
}
