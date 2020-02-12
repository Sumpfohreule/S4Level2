########################################################################################################################
if (!exists("level2")) {
    level2 <- loadL2Object()
}

# Add Conventwald Plot and SubPlots
plot_name = "Conventwald"
level2 <- createAndAddPlot(level2,
    plot_name = plot_name,
    corrected.aggregate.path =  "O:/PROJEKT/NIEDER/LOGGER/Convent/Conventwald_gesamt_Korrektur")

plot_uri <- URI(file.path(plot_name))
level2 <- createAndAddMultipleSubPlots(level2,
    .PlotURI = plot_uri)

# CO Buche
co_bu_accessDB_uri <- URI(plot_name, "Buche", "AccessDB")
level2 <- createAndAddAccessDBObject(level2,
    source_paths = "O:/PROJEKT/CONVENT/LOGDATEN/DBDAT/Conventwald.mdb",
    .URI = co_bu_accessDB_uri,
    table_name = "DL6_BBU5",
    date_column = "Dat_Zeit")

level2 <- addSensorMapping(level2,
    pattern = "^Regen",
    replacement = "PR_",
    .URI = co_bu_accessDB_uri)
level2 <- addSensorMapping(level2,
    pattern = "^Se",
    replacement = "SE",
    .URI = co_bu_accessDB_uri)
level2 <- addSensorMapping(level2,
    pattern = "^bbu5stam$",
    replacement = "Stammabfluss",
    .URI = co_bu_accessDB_uri)
level2 <- addSensorMapping(level2,
    pattern = "^FDR([0-9]{2})([xyz])$",
    replacement = "\\1_FDR_\\2",
    .URI = co_bu_accessDB_uri)
level2 <- addSensorMapping(level2,
    pattern = "^PF([0-9]{2})([xyz])$",
    replacement = "\\1_PF_mV_\\2",
    .URI = co_bu_accessDB_uri)
level2 <- addSensorMapping(level2,
    pattern = "_x$",
    replacement = "_X",
    .URI = co_bu_accessDB_uri)
level2 <- addSensorMapping(level2,
    pattern = "_y$",
    replacement = "_Y",
    .URI = co_bu_accessDB_uri)
level2 <- addSensorMapping(level2,
    pattern = "_z$",
    replacement = "_Z",
    .URI = co_bu_accessDB_uri)

# CO Fichte
co_fi_envi_uri <- URI("Conventwald/Fichte/Envilog")
co_fi_envi_paths <- c(
    "O:/PROJEKT/CONVENT/LOGDATEN/ROHDAT/DL4-WFI4/wfi4_pF_meter_csv",
    "O:/PROJEKT/NIEDER/LOGGER/Convent/Co_Fi_envilog/Rohdata")
level2 <- createAndAddLogger(level2,
    logger_type = "Envilog",
    source_paths = co_fi_envi_paths,
    .URI = co_fi_envi_uri)

co_fi_adlm_uri <- URI("Conventwald/Fichte/ADLM")
level2 <- createAndAddLogger(level2,
    logger_type = "ADLM",
    source_paths = "O:/PROJEKT/NIEDER/LOGGER/Convent/Convent_Fi_ADLM/csv",
    .URI = co_fi_adlm_uri)

level2 <- addSensorMapping(level2,
    pattern = "\\.Theta\\.",
    replacement = "_FDR_",
    .URI = co_fi_adlm_uri)
level2 <- addSensorMapping(level2,
    pattern = "(?<=_FDR_)K$",
    replacement = "X",
    .URI = co_fi_adlm_uri)
level2 <- addSensorMapping(level2,
    pattern = "(?<=_FDR_)KR$",
    replacement = "Y",
    .URI = co_fi_adlm_uri)
level2 <- addSensorMapping(level2,
    pattern = "(?<=_FDR_)L$",
    replacement = "Z",
    .URI = co_fi_adlm_uri)
level2 <- addSensorMapping(level2,
    pattern = "^Regen",
    replacement = "PR_",
    .URI = co_fi_adlm_uri)


# CO Freiland
co_frei_adlm_uri <- URI("Conventwald/Freiland/ADLM")
level2 <- createAndAddLogger(level2,
    logger_type = "ADLM",
    source_paths = "O:/PROJEKT/NIEDER/LOGGER/Convent/Convent_ADLM_Turm/csv",
    .URI = co_frei_adlm_uri)

level2 <- addSensorMapping(level2,
    pattern = "^Hygro\\.S3\\.Temperatur$",
    replacement = "AT",
    .URI = co_frei_adlm_uri)
level2 <- addSensorMapping(level2,
    pattern = "^Hygro\\.S3\\.r\\.Feuchte$",
    replacement = "RH",
    .URI = co_frei_adlm_uri)
level2 <- addSensorMapping(level2,
    pattern = "^Niederschlag$",
    replacement = "PR",
    .URI = co_frei_adlm_uri)
level2 <- addSensorMapping(level2,
    pattern = "^SP\\.Lite2?\\.Pyranometer$",
    replacement = "SR",
    .URI = co_frei_adlm_uri)
level2 <- addSensorMapping(level2,
    pattern = "^Windgeschwindigkeit$",
    replacement = "WS",
    .URI = co_frei_adlm_uri)
level2 <- addSensorMapping(level2,
    pattern = "^Windrichtung",
    replacement = "WD",
    .URI = co_frei_adlm_uri)

saveL2Object(level2)
rm(level2, co_fi_adlm_uri, co_fi_envi_uri, co_frei_adlm_uri)


