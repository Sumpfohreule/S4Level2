oc_base_path <- "/home/polarfalke/Data/Nextcloud/Arbeit/FVA/O/PROJEKT/NIEDER/Logger/OCHS"
oc_plot <- xml_createPlot(
    plot_name = "Ochsenhausen",
    screened_data_path = file.path(oc_base_path, "Ochsenhausen_gesamt_Korrektur"))

# Buche
# DeltaT
oc_bu_delta <- xml_createLogger(
    type = "DeltaT",
    sub_plot = "Buche",
    source_paths = file.path(oc_base_path, "Ochsenhausen_Buche_Delta_T/Backup.dat"))
xml_addSensorMapping(
    xml_logger = oc_bu_delta,
    pattern = "^FDR([0-9]{2})([xyz])$",
    replacement = "\\1_FDR_\\2")
xml_addSensorMapping(
    xml_logger = oc_bu_delta,
    pattern = "^PF([0-9]{2})([xyz])$",
    replacement = "\\1_PF_mV_\\2")
xml_addSensorMapping(
    xml_logger = oc_bu_delta,
    pattern = "_x$",
    replacement = "_X")
xml_addSensorMapping(
    xml_logger = oc_bu_delta,
    pattern = "_y$",
    replacement = "_Y")
xml_addSensorMapping(
    xml_logger = oc_bu_delta,
    pattern = "_z$",
    replacement = "_Z")
xml_addSensorMapping(
    xml_logger = oc_bu_delta,
    pattern = "^Regen",
    replacement = "PR_")
xml2::xml_add_child(oc_plot, oc_bu_delta)

# ADLM
oc_bu_adlm <- xml_createLogger(
    type = "ADLM",
    sub_plot = "Buche",
    source_paths = file.path(oc_base_path, "Ochsenhausen_Bu_ADLM/CSV"))
xml_addSensorMapping(
    xml_logger = oc_bu_adlm,
    pattern = "Regen",
    replacement = "PR_")
xml2::xml_add_child(oc_plot, oc_bu_adlm)

# Fichte
# ADLM
oc_fi_adlm <- xml_createLogger(
    type = "ADLM",
    sub_plot = "Fichte",
    source_paths = file.path(oc_base_path, "Ochs_PF_Meter_1/CSV"))
xml_addSensorMapping(
    xml_logger = oc_fi_adlm,
    pattern = "^Regen",
    replacement = "PR_")
xml_addSensorMapping(
    xml_logger = oc_fi_adlm,
    pattern = "^([0-9]{2})([KL]R?)\\.OC\\.FI\\.TDR$",
    replacement = "\\1_FDR_\\2")
# Excluding mappings for now as they contain very problamatic data (ca. before 2013) which should not be used
#oc.adlm.fi <- addSensorMapping(oc.adlm.fi,
#    pattern = "^PF_OC_FI_([0-9]{2})([KL]R?)\\.Temp$",
#    replacement = "\\1_T_PF_\\2")
#oc.adlm.fi <- addSensorMapping(oc.adlm.fi,
#    pattern = "^PF_OC_FI_([0-9]{2})([KL]R?)$",
#    replacement = "\\1_MP_\\2")
xml_addSensorMapping(
    xml_logger = oc_fi_adlm,
    pattern = "_K$",
    replacement = "_X")
xml_addSensorMapping(
    xml_logger = oc_fi_adlm,
    pattern = "_KR$",
    replacement = "_Y")
xml_addSensorMapping(
    xml_logger = oc_fi_adlm,
    pattern = "_L$",
    replacement = "_Z")
xml2::xml_add_child(oc_plot, oc_fi_adlm)

# Envilog
oc_fi_envilog <- xml_createLogger(
    type = "Envilog",
    sub_plot = "Fichte",
    source_paths = file.path(oc_base_path, "Ochsenhausen_Fichte_unged\u00FCngt_envilog"))
xml2::xml_add_child(oc_plot, oc_fi_envilog)

# Freiland
oc_frei_adlm <- xml_createLogger(
    type = "ADLM",
    sub_plot = "Freiland",
    source_paths = file.path(oc_base_path, "Ochsenhausen_1/CSV"))
xml_addSensorMapping(
    xml_logger = oc_frei_adlm,
    pattern = "^Niederschlag$",
    replacement = "PR")
xml_addSensorMapping(
    xml_logger = oc_frei_adlm,
    pattern = "^LT$",
    replacement = "AT")
xml_addSensorMapping(
    xml_logger = oc_frei_adlm,
    pattern = "^Hygro\\.S3\\.Temperatur$",
    replacement = "AT")
xml_addSensorMapping(
    xml_logger = oc_frei_adlm,
    pattern = "^LF$",
    replacement = "RH")
xml_addSensorMapping(
    xml_logger = oc_frei_adlm,
    pattern = "^Hygro\\.S3\\.r\\.Feuchte$",
    replacement = "RH")
xml_addSensorMapping(
    xml_logger = oc_frei_adlm,
    pattern = "^GBL$",
    replacement = "SR")
xml_addSensorMapping(
    xml_logger = oc_frei_adlm,
    pattern = "^SP\\.Lite2\\.Pyranometer$",
    replacement = "SR")
xml_addSensorMapping(
    xml_logger = oc_frei_adlm,
    pattern = "^WG$",
    replacement = "WS")
xml_addSensorMapping(
    xml_logger = oc_frei_adlm,
    pattern = "^Windgeschwindigkeit$",
    replacement = "WS")
xml_addSensorMapping(
    xml_logger = oc_frei_adlm,
    pattern = "^WR$",
    replacement = "WD")
xml_addSensorMapping(
    xml_logger = oc_frei_adlm,
    pattern = "^Windrichtung",
    replacement = "WD")
xml2::xml_add_child(oc_plot, oc_frei_adlm)
xml2::write_xml(oc_plot, "/home/polarfalke/Data/Temp/level2/ochsenhausen_setup.xml")
