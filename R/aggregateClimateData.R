########################################################################################################################
aggregateClimateData <- function(plot) {
    column_selection <- c('Lufttemperatur', 'Precipitation', 'PR', 'Luftfeuchte', 'Windgeschwindigkeit',
        'SolarRadiation', 'AT', 'RH', 'WS', 'SR', 'Pluvio_mm','Niederschlag.Casella')
    
    freiland_import <- loadCorrectedData(
        .Object = loadL2Object(plot),
        sheet.name = "Freiland")
    
    climate_data <- freiland_import %>%
        filter(variable %in% column_selection) %>%
        mutate(variable = remapLevels(variable, pattern = "^Lufttemperatur$", replacement = "AT")) %>%
        mutate(variable = remapLevels(variable, pattern = "^Precipitation|Niederschlag.Casella$", replacement = "PR")) %>%
        mutate(variable = remapLevels(variable, pattern = "^Luftfeuchte$", replacement = "RH")) %>%
        mutate(variable = remapLevels(variable, pattern = "^SolarRadiation$", replacement = "SR")) %>%
        mutate(variable = remapLevels(variable, pattern = "^Windgeschwindigkeit", replacement = "WS")) %>%
        mutate(value = if_else(abs(value) == 9999, true = as.numeric(NA), false = value)) %>%
        na.omit() %>%
        data.table() %>%
        unique(by = c("Datum", "variable")) %>%
        spread(variable, value)
    
    climate_data <- climate_data %>%
        mutate(RH = if_else(RH > 100, true = 100, false = RH)) %>%
        mutate(PR = if_else(!is.na(Pluvio_mm), true = Pluvio_mm, false = PR)) %>%
        select(-Pluvio_mm)
    
    output <- climate_data %>%
        mutate(Datum = as.Date(Datum)) %>%
        group_by(Datum) %>%
        summarise(
            Temperaturmittel = round(mean(AT, na.rm = TRUE), digits = 2),
            Temperaturmaximum = max(AT, na.rm = TRUE),
            Temperaturminimum = min(AT, na.rm = TRUE),
            Niederschlag = sum(PR, na.rm = TRUE),
            GlobalstrahlungTagesmittel_Wm2 = round(mean(SR, na.rm = TRUE), digits = 2),
            Windgeschwindigkeit = round(mean(WS, na.rm = TRUE), digits = 2),
            Luftfeuchte = round(mean(RH, na.rm = TRUE), digits = 2)) %>%
        mutate_at(.vars = vars(-Datum), .funs = ~if_else(is.finite(.), true = ., false = as.numeric(NA)))
    
    out_path <- "Data/output"
    out_file <- paste0(plot, "_Klima_Aggregation.xlsx")
    write.xlsx(output, file = file.path(out_path, out_file))
}
