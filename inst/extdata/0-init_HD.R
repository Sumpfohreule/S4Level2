hd_plot <- xml_createPlot(
    plot_name = "Heidelberg",
    screened_data_path = "O:/PROJEKT/NIEDER/LOGGER/HEIDELBG/Heidelberg_ges_Korrektur")

# Buche
# DeltaT
hd_bu_delta <- xml_createLogger(
    type = "DeltaT",
    sub_plot = "Buche",
    source_paths = "O:/PROJEKT/NIEDER/LOGGER/HEIDELBG/Heidelberg_Bu/Heidelberg_Bu_Delta_T/Backup.dat")
xml_addSensorMapping(
    xml_logger = hd_bu_delta,
    pattern = "Regen",
    replacement = "PR_")
xml_addSensorMapping(
    xml_logger = hd_bu_delta,
    pattern = "x$",
    replacement = "X")
xml_addSensorMapping(
    xml_logger = hd_bu_delta,
    pattern = "y$",
    replacement = "Y")
xml_addSensorMapping(
    xml_logger = hd_bu_delta,
    pattern = "z$",
    replacement = "Z")
xml_addSensorMapping(
    xml_logger = hd_bu_delta,
    pattern = "(FDR|PF)([0-9]{2})([XYZ])",
    replacement = "\\2_\\1_\\3")
xml_addSensorMapping(
    xml_logger = hd_bu_delta,
    pattern = "_PF_",
    replacement = "_PF_mV_")
xml2::xml_add_child(hd_plot, hd_bu_delta)

# ADLM
hd_bu_adlm <- xml_createLogger(
    type = "ADLM",
    sub_plot = "Buche",
    source_paths = "O:/PROJEKT/NIEDER/LOGGER/HEIDELBG/Heidelberg_Bu/Heidelberg_Bu_ADL/csv")
xml_addSensorMapping(
    xml_logger = hd_bu_adlm,
    pattern = "Regen",
    replacement = "PR_")
xml_addSensorMapping(
    xml_logger = hd_bu_adlm,
    pattern = "^Stammab(fluss)*$",
    replacement = "Stammabfluss")
xml2::xml_add_child(hd_plot, hd_bu_adlm)

# Fichte
# ADLM
hd_fi_adlm <- xml_createLogger(
    type = "ADLM",
    sub_plot = "Fichte",
    source_paths = "O:/PROJEKT/NIEDER/LOGGER/HEIDELBG/Heidelberg_Fi/CSV")
xml_addSensorMapping(
    xml_logger = hd_fi_adlm,
    pattern = "Regen",
    replacement = "PR_")
xml_addSensorMapping(
    xml_logger = hd_fi_adlm,
    pattern = "^Se",
    replacement = "SE")
xml_addSensorMapping(
    xml_logger = hd_fi_adlm,
    pattern = "^([0-9]{2})([LK]R?)\\.HD.Fi\\.TDR$",
    replacement = "\\1_FDR_\\2")
xml_addSensorMapping(
    xml_logger = hd_fi_adlm,
    pattern = "^PF_\\.?HD_Fi_([0-9]{2})\\.([LK]R?)$",
    replacement = "\\1_MP_\\2")
xml_addSensorMapping(
    xml_logger = hd_fi_adlm,
    pattern = "^PF_HD_Fi_([0-9]{2})([LK]R?)\\.Te$",
    replacement = "\\1_T_PF_\\2")
xml_addSensorMapping(
    xml_logger = hd_fi_adlm,
    pattern = "_K$",
    replacement = "_X")
xml_addSensorMapping(
    xml_logger = hd_fi_adlm,
    pattern = "_KR$",
    replacement = "_Y")
xml_addSensorMapping(
    xml_logger = hd_fi_adlm,
    pattern = "_L$",
    replacement = "_Z")
xml2::xml_add_child(hd_plot, hd_fi_adlm)

# Freiland
hd_frei_adlm <- xml_createLogger(
    type = "ADLM",
    sub_plot = "Freiland",
    source_paths = "O:/PROJEKT/NIEDER/LOGGER/HEIDELBG/Heidelberg_Freiland/csv")
xml_addSensorMapping(
    xml_logger = hd_frei_adlm,
    pattern = "^Hygro\\.S3\\.Temperatur$",
    replacement = "AT")
xml_addSensorMapping(
    xml_logger = hd_frei_adlm,
    pattern = "^Hygro\\.S3\\.r\\.Feuchte$",
    replacement = "RH")
xml_addSensorMapping(
    xml_logger = hd_frei_adlm,
    pattern = "^Niederschlag$",
    replacement = "PR")
xml_addSensorMapping(
    xml_logger = hd_frei_adlm,
    pattern = "^SP\\.Lite2?\\.Pyranometer$",
    replacement = "SR")
xml_addSensorMapping(
    xml_logger = hd_frei_adlm,
    pattern = "^Windgeschwindigkeit$",
    replacement = "WS")
xml_addSensorMapping(
    xml_logger = hd_frei_adlm,
    pattern = "^Windrichtung",
    replacement = "WD")
xml2::xml_add_child(hd_plot, hd_frei_adlm)
xml2::write_xml(hd_plot, "inst/extdata/plot_xml/heidelberg_setup.xml")
