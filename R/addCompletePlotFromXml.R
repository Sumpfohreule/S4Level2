addCompletePlotFromXml <- function(level2, xml_path) {
    xml_root <- xml2::read_xml(xml_path)

    plot_name <- xml2::xml_attr(xml_root, attr = "name")
    screened_data_path <- xml2::xml_attr(xml_root, attr = "screened_data_path")

    level2 <- createAndAddPlot(level2, plot_name, screened_data_path)
    plot_dir <- level2 %>%
        getPlot(Level2URI(plot_name)) %>%
        getLocalDirectory()
    dir.create(plot_dir, showWarnings = FALSE)
    logger_nodes <- xml2::xml_children(xml_root)

    for (logger_node in logger_nodes) {
        # Create SubPlot if needed
        sub_plot_name <- xml2::xml_attr(logger_node, "sub_plot")
        sub_plot_uri <- Level2URI(plot_name, sub_plot_name)
        level2 <- createAndAddSubPlot(level2, sub_plot_name, sub_plot_uri)
        sub_plot_dir <- level2 %>%
            getSubPlot(sub_plot_uri) %>%
            getLocalDirectory()
        dir.create(sub_plot_dir, showWarnings = FALSE)


        # Create and add Logger
        logger_type <- xml2::xml_attr(logger_node, "type")
        source_paths <- xml2::xml_find_all(logger_node, "Source_Path") %>%
            xml2::xml_attr("path")
        logger_uri <- Level2URI(sub_plot_uri, logger_type)

        if (logger_type == "AccessDB") {
            db_table_name <- xml2::xml_attr(logger_node, "db_table_name")
            date_column_name <- xml2::xml_attr(logger_node, "date_column")
            level2 <- createAndAddAccessDBObject(level2,
                                         source_paths = source_paths,
                                         .URI = logger_uri,
                                         table_name = db_table_name,
                                         date_column = date_column_name)
        } else {
            level2 <- createAndAddLogger(level2,
                                         logger_type = logger_type,
                                         source_paths = source_paths,
                                         .URI = logger_uri)
        }
        logger_dir <- level2 %>%
            getDataStructure(logger_uri) %>%
            getLocalDirectory()
        dir.create(logger_dir, showWarnings = FALSE)

        # Add Sensor Mappings
        mapping_table <- xml_readMappings(logger_node)
        if (nrow(mapping_table) > 0) {
            for (mapping_index in 1:nrow(mapping_table)) {
                pattern <- mapping_table[mapping_index, "patterns"]
                replacement <- mapping_table[mapping_index, "replacements"]
                origin_date <- mapping_table[mapping_index, "origin_dates"]
                level2 <- addSensorMapping(level2,
                                           pattern,
                                           replacement,
                                           origin.date = origin_date,
                                           .URI = logger_uri)
            }
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
        dplyr::mutate_all(as.character)
    return(mapping_table)
}
