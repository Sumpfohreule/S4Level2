addPlotWithLoggersFromXML <- function(level2, xml_path) {
    xml_root <- xml2::read_xml(xml_path)

    plot_name <- xml2::xml_attr(xml_root, attr = "name")
    screened_aggregate_path <- xml2::xml_attr(xml_root, attr = "screened_aggregate_path")

    level2 <- createAndAddPlot(level2, plot_name, screened_aggregate_path)

    sub_plot_node <- xml2::xml_children(xml_root)
    sub_plot_names <- xml2::xml_attr(sub_plot_node, "name")

    for (sub_plot_index in 1:length(sub_plot_node)) {
        sub_plot_name <- sub_plot_names[sub_plot_index]
        sub_plot_uri <- Level2URI(plot_name, sub_plot_name)
        level2 <- createAndAddSubPlot(level2, sub_plot_name, sub_plot_uri)

        logger_node <- xml2::xml_children(sub_plot_node[sub_plot_index])

        for (logger_index in 1:length(logger_node)) {
            logger_type <- xml2::xml_attr(logger_node[logger_index], "type")
            source_paths <- xml2::xml_attr(logger_node[logger_index], "source_path")
            logger_uri <- Level2URI(sub_plot_uri, logger_type)

            new(logger_type,
                uri = Level2URI(plot_name, sub_plot_name, logger_type),
                local_directory = source_paths,
                paths = source_paths)
            level2 <- createAndAddLogger(level2,
                                         logger_type = logger_type,
                                         source_paths = source_paths,
                                         .URI = logger_uri)
        }

    }
    return(level2)
}