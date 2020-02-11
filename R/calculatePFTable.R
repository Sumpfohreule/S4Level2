########################################################################################################################
calculatePFTable <- function(long.l2.table) {
    # hPa calculation from pF (log) value
    hpa.from.pF.table <- long.l2.table[str_detect(variable, "^[0-9]{2}_MP_[XYZ]$") & !is.na(value), .(
            Plot,
            SubPlot,
            Datum,
            variable = str_replace(variable, pattern = "MP", replacement = "PF"),
            value = 10^value)]
    
# hPa calculation from mV value (often "Buche" SubPlot)
    hpa.from.mV.table <- long.l2.table[str_detect(variable, "^[0-9]{2}_PF_mV_[XYZ]$") & !is.na(value), .(
            Plot,
            SubPlot,
            Datum,
            variable = str_replace(variable, pattern = "PF_mV", replacement = "PF"),
            value = 10^(value / 300))]
    
# pF calculation in case of mV raw data
    pf.from.hpa.table <- hpa.from.mV.table[!is.na(value), .(
            Plot,
            SubPlot,
            Datum,
            variable = str_replace(variable, pattern = "PF", replacement = "MP"),
            value = log10(value))]
    
    return(list(hpa.from.pF.table, hpa.from.mV.table, pf.from.hpa.table))
}

