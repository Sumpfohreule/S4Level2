########################################################################################################################
if (!exists("level2")) {
    data_path = "w:/Data"
    level2 <- loadL2Object(data_path)
}

# Esslingen
plot_name <- "Esslingen"
level2 <- createAndAddPlot(level2,
    plot_name = plot_name,
    corrected.aggregate.path = "O:/PROJEKT/NIEDER/LOGGER/ESSLINGN/FVA/Esslingen_gesamt_Korrektur")

.PlotURI <- Level2URI(plot_name)
level2 <- createAndAddMultipleSubPlots(level2,
    .PlotURI = .PlotURI)

# ES Buche
es_bu_deltaT_URI <- Level2URI(.PlotURI, "Buche", "DeltaT")
level2 <- createAndAddLogger(level2,
    logger_type = "DeltaT",
    source_paths = "O:/PROJEKT/NIEDER/LOGGER/ESSLINGN/FVA/Esslingen_Buche_DeltaT/Backup.dat",
    .URI = es_bu_deltaT_URI)

level2 <- addSensorMapping(level2,
    pattern = "Regen",
    replacement = "PR_",
    .URI = es_bu_deltaT_URI)
level2 <- addSensorMapping(level2,
    pattern = "x$",
    replacement = "X",
    .URI = es_bu_deltaT_URI)
level2 <- addSensorMapping(level2,
    pattern = "y$",
    replacement = "Y",
    .URI = es_bu_deltaT_URI)
level2 <- addSensorMapping(level2,
    pattern = "z$",
    replacement = "Z",
    .URI = es_bu_deltaT_URI)
level2 <- addSensorMapping(level2,
    pattern = "(PF|FDR)([0-9]{2})([XYZ])",
    replacement = "\\2_\\1_\\3",
    .URI = es_bu_deltaT_URI)
level2 <- addSensorMapping(level2,
    pattern = "PF",
    replacement = "PF_mV",
    .URI = es_bu_deltaT_URI)
# Missnamed Dendrometer
# FIXME: Limit the scope of patching wrong names to only determined time frame
level2 <- addSensorMapping(level2,
    pattern = "SE907",
    replacement = "SE904",
    .URI = es_bu_deltaT_URI)

es_bu_tinytag_uri <- Level2URI(.PlotURI, "Buche", "TinyTag")
level2 <- createAndAddLogger(level2,
    logger_type = "TinyTag",
    source_paths = "O:/PROJEKT/NIEDER/LOGGER/ESSLINGN/FVA/Esslingen_Buche_TinyTag/backup.txt",
    .URI = es_bu_tinytag_uri)

level2 <- addSensorMapping(level2,
    pattern = "(FDR|PF)([0-9]{2})",
    replacement = "\\2_\\1_",
    .URI = es_bu_tinytag_uri)
level2 <- addSensorMapping(level2,
    pattern = "PF",
    replacement = "PF_mV",
    .URI = es_bu_tinytag_uri)
level2 <- addSensorMapping(level2,
    pattern = "x$",
    replacement = "X",
    .URI = es_bu_tinytag_uri)
level2 <- addSensorMapping(level2,
    pattern = "y$",
    replacement = "Y",
    .URI = es_bu_tinytag_uri)
level2 <- addSensorMapping(level2,
    pattern = "z$",
    replacement = "Z",
    .URI = es_bu_tinytag_uri)
level2 <- addSensorMapping(level2,
    pattern = "Regen",
    replacement = "PR_",
    .URI = es_bu_tinytag_uri)

# ES Fichte
es_fi_ADLM_uri = Level2URI(.PlotURI, "Fichte", "ADLM")
level2 <- createAndAddLogger(level2,
    logger_type = "ADLM",
    source_paths = "O:/PROJEKT/NIEDER/LOGGER/ESSLINGN/FVA/Esslingen_PF_Meter_1/csv",
    .URI = es_fi_ADLM_uri)

level2 <- addSensorMapping(level2,
    pattern = "(?<=[0-9]{2})K(?=\\.ES\\.Fi\\.TDR)",
    replacement = "X",
    .URI = es_fi_ADLM_uri)
level2 <- addSensorMapping(level2,
    pattern = "(?<=[0-9]{2})KR(?=\\.ES\\.Fi\\.TDR)",
    replacement = "Y",
    .URI = es_fi_ADLM_uri)
level2 <- addSensorMapping(level2,
    pattern = "(?<=[0-9]{2})L(?=\\.ES\\.Fi\\.TDR)",
    replacement = "Z",
    .URI = es_fi_ADLM_uri)
level2 <- addSensorMapping(level2,
    pattern = "([0-9]{2})([XYZ])\\.ES\\.Fi\\.TDR",
    replacement = "\\1_FDR_\\2",
    .URI = es_fi_ADLM_uri)
level2 <- addSensorMapping(level2,
    pattern = "Niederschlag",
    replacement = "PR",
    .URI = es_fi_ADLM_uri)

es_fi_envilog_uri <- Level2URI(.PlotURI, "Fichte", "Envilog")
level2 <- createAndAddLogger(level2,
    logger_type = "Envilog",
    source_paths = "O:/PROJEKT/NIEDER/LOGGER/ESSLINGN/FVA/Esslingen_Fichte_envilog",
    .URI = es_fi_envilog_uri)

# Old logger, removed until it can be excempted from createAggregateExcel
#es.deltaT.fi.path <- "O:/PROJEKT/NIEDER/LOGGER/ESSLINGN/FVA/Esslingen_Fichte_DeltaT"
#es.deltaT.fi <- new("DeltaT", paths = es.deltaT.fi.path)
#es.plot <- addLogger(es.plot, .DataStructure = es.deltaT.fi, sub.plot = "Fichte")

# ES Freiland
es_frei_ADLM_uri <- Level2URI(.PlotURI, "Freiland", "ADLM")
level2 <- createAndAddLogger(level2,
    logger_type = "ADLM",
    source_paths = "O:/PROJEKT/NIEDER/LOGGER/ESSLINGN/FVA/Esslingen_1/CSV",
    .URI = es_frei_ADLM_uri)

level2 <- addSensorMapping(level2,
    pattern = "Hygro\\.S3\\.Temperatur",
    replacement = "AT",
    .URI = es_frei_ADLM_uri)
level2 <- addSensorMapping(level2,
    pattern = "Hygro\\.S3\\.r\\.Feuchte",
    replacement = "RH",
    .URI = es_frei_ADLM_uri)
level2 <- addSensorMapping(level2,
    pattern = "Niederschlag",
    replacement = "PR",
    .URI = es_frei_ADLM_uri)
level2 <- addSensorMapping(level2,
    pattern = "SP\\.Lite2?\\.Pyranometer",
    replacement = "SR",
    .URI = es_frei_ADLM_uri)
level2 <- addSensorMapping(level2,
    pattern = "Windgeschwindigkeit",
    replacement = "WS",
    .URI = es_frei_ADLM_uri)
level2 <- addSensorMapping(level2,
    pattern = "Windrichtung",
    replacement = "WD",
    .URI = es_frei_ADLM_uri)

saveL2Object(level2)
rm(level2, plot_name, .PlotURI, es_bu_deltaT_URI, es_bu_tinytag_uri, es_fi_ADLM_uri, es_fi_envilog_uri,
    es_frei_ADLM_uri)


