########################################################################################################################
es_base_path <- "/home/polarfalke/Data/Nextcloud/Arbeit/FVA/O/PROJEKT/NIEDER/Logger/Esslingen"
es_plot <- xml_createPlot(
    plot_name = "Esslingen",
    screened_data_path = file.path(es_base_path, "Esslingen_gesamt_Korrektur"))

es_bu_delta <- xml_createLogger(
    type = "DeltaT",
    sub_plot = "Buche",
    source_paths = file.path(es_base_path, "Esslingen_Buche_DeltaT/Backup.dat"))
xml_addSensorMapping(
    xml_logger = es_bu_delta,
    pattern = "Regen",
    replacement = "PR_")
xml_addSensorMapping(
    xml_logger = es_bu_delta,
    pattern = "x$",
    replacement = "X")
xml_addSensorMapping(
    xml_logger = es_bu_delta,
    pattern = "y$",
    replacement = "Y")
xml_addSensorMapping(
    xml_logger = es_bu_delta,
    pattern = "z$",
    replacement = "Z")
xml_addSensorMapping(
    xml_logger = es_bu_delta,
    pattern = "(PF|FDR)([0-9]{2})([XYZ])",
    replacement = "\\2_\\1_\\3")
xml_addSensorMapping(
    xml_logger = es_bu_delta,
    pattern = "PF",
    replacement = "PF_mV")
# Missnamed Dendrometer
# FIXME: Limit the scope of patching wrong names to only determined time frame
xml_addSensorMapping(
    xml_logger = es_bu_delta,
    pattern = "SE907",
    replacement = "SE904")
xml2::xml_add_child(es_plot, es_bu_delta)


es_bu_tinytag <- xml_createLogger(
    type = "TinyTag",
    sub_plot = "Buche",
    source_paths = file.path(es_base_path, "Esslingen_Buche_TinyTag/backup.txt"))
xml_addSensorMapping(
    xml_logger = es_bu_tinytag,
    pattern = "(FDR|PF)([0-9]{2})",
    replacement = "\\2_\\1_")
xml_addSensorMapping(
    xml_logger = es_bu_tinytag,
    pattern = "PF",
    replacement = "PF_mV")
xml_addSensorMapping(
    xml_logger = es_bu_tinytag,
    pattern = "x$",
    replacement = "X")
xml_addSensorMapping(
    xml_logger = es_bu_tinytag,
    pattern = "y$",
    replacement = "Y")
xml_addSensorMapping(
    xml_logger = es_bu_tinytag,
    pattern = "z$",
    replacement = "Z")
xml_addSensorMapping(
    xml_logger = es_bu_tinytag,
    pattern = "Regen",
    replacement = "PR_")
xml2::xml_add_child(es_plot, es_bu_tinytag)

# ES Fichte
es_fi_adlm <- xml_createLogger(
    type = "ADLM",
    sub_plot = "Fichte",
    source_paths = file.path(es_base_path, "Esslingen_PF_Meter_1/csv"))
xml_addSensorMapping(
    xml_logger = es_fi_adlm,
    pattern = "(?<=[0-9]{2})K(?=\\.ES\\.Fi\\.TDR)",
    replacement = "X")
xml_addSensorMapping(
    xml_logger = es_fi_adlm,
    pattern = "(?<=[0-9]{2})KR(?=\\.ES\\.Fi\\.TDR)",
    replacement = "Y")
xml_addSensorMapping(
    xml_logger = es_fi_adlm,
    pattern = "(?<=[0-9]{2})L(?=\\.ES\\.Fi\\.TDR)",
    replacement = "Z")
xml_addSensorMapping(
    xml_logger = es_fi_adlm,
    pattern = "([0-9]{2})([XYZ])\\.ES\\.Fi\\.TDR",
    replacement = "\\1_FDR_\\2")
xml_addSensorMapping(
    xml_logger = es_fi_adlm,
    pattern = "Niederschlag",
    replacement = "PR")
xml2::xml_add_child(es_plot, es_fi_adlm)

# Old logger, removed until it can be excempted from createAggregateExcel
#es.deltaT.fi.path <- "O:/PROJEKT/NIEDER/LOGGER/ESSLINGN/FVA/Esslingen_Fichte_DeltaT"
#es.deltaT.fi <- new("DeltaT", paths = es.deltaT.fi.path)
#es.plot <- addLogger(es.plot, .DataStructure = es.deltaT.fi, sub.plot = "Fichte")

# ES Freiland
es_frei_adlm <- xml_createLogger(
    type = "ADLM",
    sub_plot = "Freiland",
    source_paths = file.path(es_base_path, "Esslingen_1/CSV"))
xml_addSensorMapping(
    xml_logger = es_frei_adlm,
    pattern = "Hygro\\.S3\\.Temperatur",
    replacement = "AT")
xml_addSensorMapping(
    xml_logger = es_frei_adlm,
    pattern = "Hygro\\.S3\\.r\\.Feuchte",
    replacement = "RH")
xml_addSensorMapping(
    xml_logger = es_frei_adlm,
    pattern = "Niederschlag",
    replacement = "PR")
xml_addSensorMapping(
    xml_logger = es_frei_adlm,
    pattern = "SP\\.Lite2?\\.Pyranometer",
    replacement = "SR")
xml_addSensorMapping(
    xml_logger = es_frei_adlm,
    pattern = "Windgeschwindigkeit",
    replacement = "WS")
xml_addSensorMapping(
    xml_logger = es_frei_adlm,
    pattern = "Windrichtung",
    replacement = "WD")
xml2::xml_add_child(es_plot, es_frei_adlm)
xml2::write_xml(es_plot, "/home/polarfalke/Data/Temp/level2/esslingen_setup.xml")

