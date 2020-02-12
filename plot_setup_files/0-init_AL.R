########################################################################################################################
if (!exists("level2")) {
    level2 <- loadL2Object()
}

# Add Altensteig Plot and SubPlots
plot_name = "Altensteig"
level2 <- createAndAddPlot(level2,
    plot_name = plot_name,
    corrected.aggregate.path = "O:/PROJEKT/NIEDER/LOGGER/ALTENST/AT_ges_Korrektur")

plot_uri <- URI(plot_name)
level2 <- createAndAddMultipleSubPlots(level2, .PlotURI = plot_uri)

# AL Freiland
al_freiland_adlm_uri <- URI("Altensteig/Freiland/ADLM")
level2 <- createAndAddLogger(
    level2,
    logger_type = "ADLM",
    source_paths = "O:/PROJEKT/NIEDER/LOGGER/ALTENST/Altensteig_1/CSV",
    .URI = al_freiland_adlm_uri)

level2 <- addSensorMapping(level2,
    pattern = "_?.AL.(FI|BU)",
    replacement = "",
    .URI = al_freiland_adlm_uri)
level2 <- addSensorMapping(level2,
    pattern = "Hygro.S3.Temperatur",
    replacement = "AT",
    .URI = al_freiland_adlm_uri)
level2 <- addSensorMapping(level2,
    pattern = "Niederschlag",
    replacement = "PR",
    .URI = al_freiland_adlm_uri)
level2 <- addSensorMapping(level2,
    pattern = "Hygro.S3.r.Feuchte",
    replacement = "RH",
    .URI = al_freiland_adlm_uri)
level2 <- addSensorMapping(level2,
    pattern = "Windgeschwindigkeit",
    replacement = "WS",
    .URI = al_freiland_adlm_uri)
level2 <- addSensorMapping(level2,
    pattern = "Windrichtung",
    replacement = "WD",
    .URI = al_freiland_adlm_uri)
level2 <- addSensorMapping(level2,
    pattern = "SP.Lite2.Pyranometer",
    replacement = "SR",
    .URI = al_freiland_adlm_uri)


# AL Buche
al_buche_adlm_uri <- URI(file.path(plot_name, "Buche", "ADLM"))
level2 <- createAndAddLogger(level2,
    logger_type = "ADLM",
    source_paths = "O:/PROJEKT/NIEDER/LOGGER/ALTENST/Altensteig_BU_1/CSV",
    .URI = al_buche_adlm_uri)

level2 <- addSensorMapping(level2,
    pattern = "_?.AL.(FI|BU)",
    replacement = "",
    .URI = al_buche_adlm_uri)
level2 <- addSensorMapping(level2,
    pattern = "PF_([0-9]{2})\\.([LK]R?)",
    replacement = "\\1_MP_\\2",
    .URI = al_buche_adlm_uri)
level2 <- addSensorMapping(level2,
    pattern = "PF_([0-9]{2})([LK]R?)\\.Temp",
    replacement = "\\1_T_PF_\\2",
    .URI = al_buche_adlm_uri)
level2 <- addSensorMapping(level2,
    pattern = "([0-9]{2})([LK]R?)\\.FDR",
    replacement = "\\1_FDR_\\2",
    .URI = al_buche_adlm_uri)
level2 <- addSensorMapping(level2,
    pattern = "^Stammab(fluss)*$",
    replacement = "Stammabfluss",
    .URI = al_buche_adlm_uri)
level2 <- addSensorMapping(level2,
    pattern = "^Regen",
    replacement = "PR_",
    .URI = al_buche_adlm_uri)
level2 <- addSensorMapping(level2,
    pattern = "_K$",
    replacement = "_X",
    .URI = al_buche_adlm_uri)
level2 <- addSensorMapping(level2,
    pattern = "_KR$",
    replacement = "_Y",
    .URI = al_buche_adlm_uri)
level2 <- addSensorMapping(level2,
    pattern = "_L$",
    replacement = "_Z",
    .URI = al_buche_adlm_uri)

# AL Fichte
al_fichte_adlm_uri <- URI("Altensteig/Fichte/ADLM")
level2 <- createAndAddLogger(level2,
    logger_type = "ADLM",
    source_paths = "O:/PROJEKT/NIEDER/LOGGER/ALTENST/Altensteig_Fi_1/CSV",
    .URI = al_fichte_adlm_uri)
level2 <- addSensorMapping(level2,
    pattern = "_?.AL.(FI|BU)",
    replacement = "",
    .URI = al_fichte_adlm_uri)
level2 <- addSensorMapping(level2,
    pattern = "PF_([0-9]{2})\\.([LK]R?)",
    replacement = "\\1_MP_\\2",
    .URI = al_fichte_adlm_uri)
level2 <- addSensorMapping(level2,
    pattern = "PF_([0-9]{2})([LK]R?)\\.Temp",
    replacement = "\\1_T_PF_\\2",
    .URI = al_fichte_adlm_uri)
level2 <- addSensorMapping(level2,
    pattern = "([0-9]{2})([LK]R?)\\.FDR",
    replacement = "\\1_FDR_\\2",
    .URI = al_fichte_adlm_uri)
level2 <- addSensorMapping(level2,
    pattern = "^Regen",
    replacement = "PR_",
    .URI = al_fichte_adlm_uri)
level2 <- addSensorMapping(level2,
    pattern = "_K$",
    replacement = "_X",
    .URI = al_fichte_adlm_uri)
level2 <- addSensorMapping(level2,
    pattern = "_KR$",
    replacement = "_Y",
    .URI = al_fichte_adlm_uri)
level2 <- addSensorMapping(level2,
    pattern = "_L$",
    replacement = "_Z",
    .URI = al_fichte_adlm_uri)
level2 <- addSensorMapping(level2,
    pattern = "^Temp_883$",
    replacement = "Temp_037",
    origin.date = "2013-06-05 12:30:00",
    .URI = al_fichte_adlm_uri)

saveL2Object(level2)
rm(plot_name, plot_uri, al_buche_adlm_uri, al_fichte_adlm_uri, al_freiland_adlm_uri)


