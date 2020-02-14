########################################################################################################################
if (!exists("level2")) {
    data_path = "w:/Data"
    level2 <- loadL2Object(data_path)
}
# Rotenfels
ro_plot_name <- "Rotenfels"
level2 <- createAndAddPlot(level2,
    plot_name = ro_plot_name,
    corrected.aggregate.path = "O:/PROJEKT/NIEDER/LOGGER/ROTENFEL/Rotenfels_Fichte_gesamt_Korrektur")
level2 <- createAndAddMultipleSubPlots(level2,
    .PlotURI = Level2URI(ro_plot_name),
    sub_plot_names = c("Fichte", "Freiland"))

# Fichte
ro_fi_deltaT_uri <- Level2URI(ro_plot_name, "Fichte", "DeltaT")
level2 <- createAndAddLogger(level2,
    logger_type = "DeltaT",
    source_paths = "O:/PROJEKT/NIEDER/LOGGER/ROTENFEL/Rotenfels_Fichte_DeltaT_neu/backup.dat",
    .URI = ro_fi_deltaT_uri)

level2 <- addSensorMapping(level2,
    pattern = "^K([0-9]{2})?(?!R)$",
    replacement = "X\\1",
    .URI = ro_fi_deltaT_uri)
level2 <- addSensorMapping(level2,
    pattern = "^KR([0-9]{2})?$",
    replacement = "Y\\1",
    .URI = ro_fi_deltaT_uri)
level2 <- addSensorMapping(level2,
    pattern = "^L([0-9]{2})?$",
    replacement = "Z\\1",
    .URI = ro_fi_deltaT_uri)
level2 <- addSensorMapping(level2,
    pattern = "^([XYZ])$",
    replacement = "PR_\\1",
    .URI = ro_fi_deltaT_uri)
level2 <- addSensorMapping(level2,
    pattern = "^([XYZ])([0-9]{2})$",
    replacement = "\\2_FDR_\\1",
    .URI = ro_fi_deltaT_uri)

#ro.deltaT.fi.alt.path <- "O:/PROJEKT/NIEDER/LOGGER/ROTENFEL/Rotenfels_Fichte_DeltaT_alt/backup.dat"
#ro.deltaT.fi.alt <- new("DeltaT", name = "DeltaT_alt", paths = ro.deltaT.fi.alt.path)
#ro.plot <- addLogger(ro.plot, ro.deltaT.fi.alt, "Fichte")

ro_fi_envilog_uri <- Level2URI(ro_plot_name, "Fichte", "Envilog")
level2 <- createAndAddLogger(level2,
    logger_type = "Envilog",
    source_paths = "O:/PROJEKT/NIEDER/LOGGER/ROTENFEL/Rotenfels_Fichte_Envilog",
    .URI = ro_fi_envilog_uri)

# Freiland
ro_frei_ADLM_uri <- Level2URI(ro_plot_name, "Freiland", "ADLM")
level2 <- createAndAddLogger(level2,
    logger_type = "ADLM",
    source_paths = "O:/PROJEKT/NIEDER/LOGGER/ROTENFEL/Rotenfels_1/CSV",
    .URI = ro_frei_ADLM_uri)

level2 <- addSensorMapping(level2,
    pattern = "^Hygro.S3.Temperatur$",
    replacement = "AT",
    .URI = ro_frei_ADLM_uri)
level2 <- addSensorMapping(level2,
    pattern = "^Niederschlag$",
    replacement = "PR",
    .URI = ro_frei_ADLM_uri)
level2 <- addSensorMapping(level2,
    pattern = "^Hygro.S3.r.Feuchte$",
    replacement = "RH",
    .URI = ro_frei_ADLM_uri)
level2 <- addSensorMapping(level2,
    pattern = "^SP.Lite2?.Pyranometer$",
    replacement = "SR",
    .URI = ro_frei_ADLM_uri)
level2 <- addSensorMapping(level2,
    pattern = "^Windgeschwindigkeit$",
    replacement = "WS",
    .URI = ro_frei_ADLM_uri)
level2 <- addSensorMapping(level2,
    pattern = "^Windrichtung$",
    replacement = "WD",
    .URI = ro_frei_ADLM_uri)

saveL2Object(level2)
rm(level2, ro_plot_name, ro_fi_deltaT_uri, ro_fi_envilog_uri, ro_frei_ADLM_uri)


