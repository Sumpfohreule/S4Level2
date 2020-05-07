########################################################################################################################
calculatePRTable <- function(long.l2.table) {
    # Summation of all PR columns (Niederschlag, Stammabfluss)
    pr_sum_table <- long.l2.table %>%
        filter(stringr::str_detect(variable, "PR_?[XYZ]?|Pluvio_mm|Niederschlag\\.Casella")) %>%
        filter(!is.na(value)) %>%
        group_by(Plot, SubPlot, variable) %>%
        group_modify(~ {
            output = data.frame(Datum = .x$Datum, value = cumsum(.x$value))
            return(output)
        })
    return(pr_sum_table)
}
