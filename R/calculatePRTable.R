########################################################################################################################
calculatePRTable <- function(long.l2.table) {
    # Summation of all PR columns (Niederschlag, Stammabfluss)
    pr.sum.table <- long.l2.table[stringr::str_detect(variable, "PR_?[XYZ]?|Pluvio_mm|Niederschlag\\.Casella") & !is.na(value), .(
            Datum,
            value = cumsum(value)),
        by = .(Plot, SubPlot, variable = paste0(variable, "_SUM"))]
    return(pr.sum.table)
}
