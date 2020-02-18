xml_createLogger <- function(type, sub_plot, source_paths, unique_name = type) {
    node <- xml2::xml_new_root(.value = "Logger",
                               name = unique_name,
                               type = type,
                               sub_plot = sub_plot)
    for (single_path in source_paths) {
        xml2::xml_add_child(node,
                            .value = "Source_Path",
                            path = single_path)
    }
    return(node)
}