xml_createLogger <- function(type,
                             sub_plot,
                             source_paths,
                             unique_name = type,
                             db_table_name = NULL,
                             date_column = NULL) {
    if (type == "AccessDB") {
        if (is.null(db_table_name) || is.null(date_column)) {
            stop("If Logger of Type AccessDB is created a db_table_name and date_column need to be provided!")
        }
        node <- xml2::xml_new_root(
            .value = "Logger",
            name = unique_name,
            type = type,
            sub_plot = sub_plot,
            db_table_name = db_table_name,
            date_column = date_column)
    } else {
        node <- xml2::xml_new_root(
            .value = "Logger",
            name = unique_name,
            type = type,
            sub_plot = sub_plot)
    }

    Encoding(source_paths) <- "UTF-8"
    for (single_path in source_paths) {
        xml2::xml_add_child(
            node,
            .value = "Source_Path",
            path = single_path)
    }
    return(node)
}
