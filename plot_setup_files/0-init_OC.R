########################################################################################################################
if (!exists("level2")) {
    level2 <- loadL2Object()
}

# Ochsenhausen
oc_plot_name = "Ochsenhausen"
level2 <- createAndAddPlot(level2,
    plot_name = oc_plot_name,
    corrected.aggregate.path = "O:/PROJEKT/NIEDER/LOGGER/OCHS/Ochsenhausen_gesamt_Korrektur")
level2 <- createAndAddMultipleSubPlots(level2,
    .PlotURI = URI(oc_plot_name))

# OC Buche
oc_bu_DeltaT_uri <- URI(oc_plot_name, "Buche", "DeltaT")
level2 <- createAndAddLogger(level2,
    logger_type = "DeltaT",
    source_paths = "O:/PROJEKT/NIEDER/LOGGER/OCHS/Ochsenhausen_Buche_Delta_T/Backup.dat",
    .URI = oc_bu_DeltaT_uri)

level2 <- addSensorMapping(level2,
    pattern = "^FDR([0-9]{2})([xyz])$",
    replacement = "\\1_FDR_\\2",
    .URI = oc_bu_DeltaT_uri)
level2 <- addSensorMapping(level2,
    pattern = "^PF([0-9]{2})([xyz])$",
    replacement = "\\1_PF_mV_\\2",
    .URI = oc_bu_DeltaT_uri)
level2 <- addSensorMapping(level2,
    pattern = "_x$",
    replacement = "_X",
    .URI = oc_bu_DeltaT_uri)
level2 <- addSensorMapping(level2,
    pattern = "_y$",
    replacement = "_Y",
    .URI = oc_bu_DeltaT_uri)
level2 <- addSensorMapping(level2,
    pattern = "_z$",
    replacement = "_Z",
    .URI = oc_bu_DeltaT_uri)
level2 <- addSensorMapping(level2,
    pattern = "^Regen",
    replacement = "PR_",
    .URI = oc_bu_DeltaT_uri)

oc_buche_ADLM_uri <- URI(oc_plot_name, "Buche", "ADLM")
level2 <- createAndAddLogger(level2,
    logger_type = "ADLM",
    source_paths = "O:/PROJEKT/NIEDER/LOGGER/OCHS/Ochsenhausen_Bu_ADLM/CSV",
    .URI = oc_buche_ADLM_uri)

level2 <- addSensorMapping(level2,
    pattern = "Regen",
    replacement = "PR_",
    .URI = oc_buche_ADLM_uri)


# OC Fichte
oc_fi_ADLM_uri <- URI(oc_plot_name, "Fichte", "ADLM")
level2 <- createAndAddLogger(level2,
    logger_type = "ADLM",
    source_paths = "O:/PROJEKT/NIEDER/LOGGER/OCHS/Ochs_PF_Meter_1/CSV",
    .URI = oc_fi_ADLM_uri)

level2 <- addSensorMapping(level2,
    pattern = "^Regen",
    replacement = "PR_",
    .URI = oc_fi_ADLM_uri)
level2 <- addSensorMapping(level2,
    pattern = "^([0-9]{2})([KL]R?)\\.OC\\.FI\\.TDR$",
    replacement = "\\1_FDR_\\2",
    .URI = oc_fi_ADLM_uri)

# Excluding mappings for now as they contain very problamatic data (ca. before 2013) which should not be used
#oc.adlm.fi <- addSensorMapping(oc.adlm.fi,
#    pattern = "^PF_OC_FI_([0-9]{2})([KL]R?)\\.Temp$",
#    replacement = "\\1_T_PF_\\2")
#oc.adlm.fi <- addSensorMapping(oc.adlm.fi,
#    pattern = "^PF_OC_FI_([0-9]{2})([KL]R?)$",
#    replacement = "\\1_MP_\\2")
level2 <- addSensorMapping(level2,
    pattern = "_K$",
    replacement = "_X",
    .URI = oc_fi_ADLM_uri)
level2 <- addSensorMapping(level2,
    pattern = "_KR$",
    replacement = "_Y",
    .URI = oc_fi_ADLM_uri)
level2 <- addSensorMapping(level2,
    pattern = "_L$",
    replacement = "_Z",
    .URI = oc_fi_ADLM_uri)

oc_fi_envilog_uri <- URI(oc_plot_name, "Fichte", "Envilog")
oc_envi_fi_path <- "O:/PROJEKT/NIEDER/LOGGER/OCHS/Ochsenhausen_Fichte_ungedüngt_envilog"
Encoding(oc_envi_fi_path) <- "UTF-8"
level2 <- createAndAddLogger(level2,
    logger_type = "Envilog",
    source_paths = oc_envi_fi_path,
    .URI = oc_fi_envilog_uri)


# OC Freiland
oc_frei_ADLM_URI <- URI(oc_plot_name, "Freiland", "ADLM")
level2 <- createAndAddLogger(level2,
    logger_type = "ADLM",
    source_paths = "O:/PROJEKT/NIEDER/LOGGER/OCHS/Ochsenhausen_1/CSV",
    .URI = oc_frei_ADLM_URI)

level2 <- addSensorMapping(level2,
    pattern = "^Niederschlag$",
    replacement = "PR",
    .URI = oc_frei_ADLM_URI)
level2 <- addSensorMapping(level2,
    pattern = "^LT$",
    replacement = "AT",
    .URI = oc_frei_ADLM_URI)
level2 <- addSensorMapping(level2,
    pattern = "^Hygro\\.S3\\.Temperatur$",
    replacement = "AT",
    .URI = oc_frei_ADLM_URI)
level2 <- addSensorMapping(level2,
    pattern = "^LF$",
    replacement = "RH",
    .URI = oc_frei_ADLM_URI)
level2 <- addSensorMapping(level2,
    pattern = "^Hygro\\.S3\\.r\\.Feuchte$",
    replacement = "RH",
    .URI = oc_frei_ADLM_URI)
level2 <- addSensorMapping(level2,
    pattern = "^GBL$",
    replacement = "SR",
    .URI = oc_frei_ADLM_URI)
level2 <- addSensorMapping(level2,
    pattern = "^SP\\.Lite2\\.Pyranometer$",
    replacement = "SR",
    .URI = oc_frei_ADLM_URI)
level2 <- addSensorMapping(level2,
    pattern = "^WG$",
    replacement = "WS",
    .URI = oc_frei_ADLM_URI)
level2 <- addSensorMapping(level2,
    pattern = "^Windgeschwindigkeit$",
    replacement = "WS",
    .URI = oc_frei_ADLM_URI)
level2 <- addSensorMapping(level2,
    pattern = "^WR$",
    replacement = "WD",
    .URI = oc_frei_ADLM_URI)
level2 <- addSensorMapping(level2,
    pattern = "^Windrichtung",
    replacement = "WD",
    .URI = oc_frei_ADLM_URI)

saveL2Object(level2)
rm(level2, oc_plot_name, oc_bu_DeltaT_uri, oc_buche_ADLM_uri, oc_envi_fi_path, oc_fi_ADLM_uri, oc_fi_envilog_uri,
    oc_frei_ADLM_URI)


