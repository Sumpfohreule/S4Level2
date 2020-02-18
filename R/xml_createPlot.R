xml_createPlot <- function(plot_name, screened_data_path) {
    node <- xml2::xml_new_root(.value = "Plot",
                               name = plot_name,
                               screened_data_path = screened_data_path)
    return(node)
}