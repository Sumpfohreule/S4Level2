########################################################################################################################
calculateDendrometerTable <- function(long.l2.table) {
    dendro_table <- long.l2.table[stringr::str_detect(variable, "^(SE|Temp)_?[0-9]{3}$")]
    dendro_table[, ":=" (
            sensor = factor(stringr::str_match(variable, "^(?:SE|Temp)(?=_?[0-9]{3}$)")),
            id = factor(stringr::str_match(variable, "(?<=^SE|Temp_?)[0-9]{3}$")))]
    if (nrow(dendro_table) > 0) {
        ohm_table <- dendro_table[sensor == "SE"]
        temp_table <- dendro_table[sensor == "Temp"]
        merged_dendro_table <- merge(
            x = ohm_table[, .SD, .SDcols = -"sensor"],
            y = temp_table[, .SD, .SDcols = -c("variable", "sensor")],
            by = c("Plot", "SubPlot", "id", "Datum"))
        setnames(merged_dendro_table,
            old = c("value.x", "value.y"),
            new = c("ohm", "temp"))

        merged_dendro_table[, value := calculateDendroSum(
                sensor_id = unique(id),
                ohm_values = ohm,
                temp_values = temp),
            by = .(id)]
        merged_dendro_table[, variable := factor(paste0("SE", id, "_\u00B5m_SUM"))]
        merged_dendro_table[, ":=" (
                id = NULL,
                ohm = NULL,
                temp = NULL)]
        return(merged_dendro_table)
    } else {
        return(NULL)
    }

}
