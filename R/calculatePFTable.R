########################################################################################################################
calculatePFTable <- function(long.l2.table) {
    reduced_table <- long.l2.table %>%
        select(Plot, SubPlot, Datum, variable, value) %>%
        filter(!is.na(value))
    # hPa calculation from pF (log) value
    hpa_from_pF <- reduced_table %>%
        filter(stringr::str_detect(variable, "^[0-9]{2}_MP_[XYZ]$")) %>%
        mutate(variable = stringr::str_replace(variable, pattern = "MP", replacement = "PF")) %>%
        mutate(value = 10^value)

    # hPa calculation from mV value (often "Buche" SubPlot)
    hpa_from_mV <- reduced_table %>%
        filter(stringr::str_detect(variable, "^[0-9]{2}_PF_mV_[XYZ]$")) %>%
        mutate(variable = stringr::str_replace(variable, pattern = "PF_mV", replacement = "PF")) %>%
        mutate(value = 10^(value / 300))
    # and pF calculation
    pf_from_hpa <- hpa_from_mV %>%
        mutate(variable = stringr::str_replace(variable, pattern = "PF", replacement = "MP")) %>%
        mutate(value = log10(value))
    return(list(hpa_from_pF, hpa_from_mV, pf_from_hpa))
}

