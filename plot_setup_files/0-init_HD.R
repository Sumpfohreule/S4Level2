########################################################################################################################
if (!exists("level2")) {
    data_path = "w:/Data"
    level2 <- loadL2Object(data_path)
}

# Heidelberg
plot_name = "Heidelberg"
level2 <- createAndAddPlot(level2,
    plot_name = plot_name,
    corrected.aggregate.path = "O:/PROJEKT/NIEDER/LOGGER/HEIDELBG/Heidelberg_ges_Korrektur")
level2 <- createAndAddMultipleSubPlots(level2,
    .PlotURI = Level2URI(plot_name))

# HD Buche
hd_bu_deltaT_uri <- Level2URI(plot_name, "Buche", "DeltaT")
level2 <- createAndAddLogger(level2,
    logger_type = "DeltaT",
    source_paths = "O:/PROJEKT/NIEDER/LOGGER/HEIDELBG/Heidelberg_Bu/Heidelberg_Bu_Delta_T/Backup.dat",
    .URI = hd_bu_deltaT_uri)
level2 <- addSensorMapping(level2,
    pattern = "Regen",
    replacement = "PR_",
    .URI = hd_bu_deltaT_uri)
level2 <- addSensorMapping(level2,
    pattern = "x$",
    replacement = "X",
    .URI = hd_bu_deltaT_uri)
level2 <- addSensorMapping(level2,
    pattern = "y$",
    replacement = "Y",
    .URI = hd_bu_deltaT_uri)
level2 <- addSensorMapping(level2,
    pattern = "z$",
    replacement = "Z",
    .URI = hd_bu_deltaT_uri)
level2 <- addSensorMapping(level2,
    pattern = "(FDR|PF)([0-9]{2})([XYZ])",
    replacement = "\\2_\\1_\\3",
    .URI = hd_bu_deltaT_uri)
level2 <- addSensorMapping(level2,
    pattern = "_PF_",
    replacement = "_PF_mV_",
    .URI = hd_bu_deltaT_uri)


hd_bu_ADLM_uri <- Level2URI(plot_name, "Buche", "ADLM")
level2 <- createAndAddLogger(level2,
    logger_type = "ADLM",
    source_paths = "O:/PROJEKT/NIEDER/LOGGER/HEIDELBG/Heidelberg_Bu/Heidelberg_Bu_ADL/csv",
    .URI = hd_bu_ADLM_uri)

level2 <- addSensorMapping(level2,
    pattern = "Regen",
    replacement = "PR_",
    .URI = hd_bu_ADLM_uri)
level2 <- addSensorMapping(level2,
    pattern = "^Stammab(fluss)*$",
    replacement = "Stammabfluss",
    .URI = hd_bu_ADLM_uri)

# HD Fichte
hd_fi_ADLM_uri <- Level2URI(plot_name, "Fichte", "ADLM")
level2 <- createAndAddLogger(level2,
    logger_type = "ADLM",
    source_paths = "O:/PROJEKT/NIEDER/LOGGER/HEIDELBG/Heidelberg_Fi/CSV",
    .URI = hd_fi_ADLM_uri)

level2 <- addSensorMapping(level2,
    pattern = "Regen",
    replacement = "PR_",
    .URI = hd_fi_ADLM_uri)
level2 <- addSensorMapping(level2,
    pattern = "^Se",
    replacement = "SE",
    .URI = hd_fi_ADLM_uri)
level2 <- addSensorMapping(level2,
    pattern = "^([0-9]{2})([LK]R?)\\.HD.Fi\\.TDR$",
    replacement = "\\1_FDR_\\2",
    .URI = hd_fi_ADLM_uri)
level2 <- addSensorMapping(level2,
    pattern = "^PF_\\.?HD_Fi_([0-9]{2})\\.([LK]R?)$",
    replacement = "\\1_MP_\\2",
    .URI = hd_fi_ADLM_uri)
level2 <- addSensorMapping(level2,
    pattern = "^PF_HD_Fi_([0-9]{2})([LK]R?)\\.Te$",
    replacement = "\\1_T_PF_\\2",
    .URI = hd_fi_ADLM_uri)
level2 <- addSensorMapping(level2,
    pattern = "_K$",
    replacement = "_X",
    .URI = hd_fi_ADLM_uri)
level2 <- addSensorMapping(level2,
    pattern = "_KR$",
    replacement = "_Y",
    .URI = hd_fi_ADLM_uri)
level2 <- addSensorMapping(level2,
    pattern = "_L$",
    replacement = "_Z",
    .URI = hd_fi_ADLM_uri)

# HD Freiland
hd_frei_ADLM_uri <- Level2URI(plot_name, "Freiland", "ADLM")
level2 <- createAndAddLogger(level2,
    logger_type = "ADLM",
    source_paths = "O:/PROJEKT/NIEDER/LOGGER/HEIDELBG/Heidelberg_Freiland/csv",
    .URI = hd_frei_ADLM_uri)

level2 <- addSensorMapping(level2,
    pattern = "^Hygro\\.S3\\.Temperatur$",
    replacement = "AT",
    .URI = hd_frei_ADLM_uri)
level2 <- addSensorMapping(level2,
    pattern = "^Hygro\\.S3\\.r\\.Feuchte$",
    replacement = "RH",
    .URI = hd_frei_ADLM_uri)
level2 <- addSensorMapping(level2,
    pattern = "^Niederschlag$",
    replacement = "PR",
    .URI = hd_frei_ADLM_uri)
level2 <- addSensorMapping(level2,
    pattern = "^SP\\.Lite2?\\.Pyranometer$",
    replacement = "SR",
    .URI = hd_frei_ADLM_uri)
level2 <- addSensorMapping(level2,
    pattern = "^Windgeschwindigkeit$",
    replacement = "WS",
    .URI = hd_frei_ADLM_uri)
level2 <- addSensorMapping(level2,
    pattern = "^Windrichtung",
    replacement = "WD",
    .URI = hd_frei_ADLM_uri)

saveL2Object(level2)
rm(level2, plot_name, hd_bu_ADLM_uri, hd_bu_deltaT_uri, hd_fi_ADLM_uri, hd_frei_ADLM_uri)


