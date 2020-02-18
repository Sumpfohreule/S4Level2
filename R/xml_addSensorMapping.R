xml_addSensorMapping <- function(xml_logger, pattern, replacement, origin_date = "") {
    node <- xml2::xml_new_root(.value = "Mapping",
                               pattern = pattern,
                               replacement = replacement,
                               origin_date = origin_date)
    xml2::xml_add_child(xml_logger, node)
}
