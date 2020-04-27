ro_base_path <- "/home/polarfalke/Data/Nextcloud/Arbeit/FVA/O/PROJEKT/NIEDER/Logger/ROTENFEL"
ro_plot <- xml_createPlot(
    plot_name = "Rotenfels",
    screened_data_path = file.path(ro_base_path, "Rotenfels_Fichte_gesamt_Korrektur"))

# Fichte
# DeltaT
ro_fi_delta <- xml_createLogger(
    type = "DeltaT",
    sub_plot = "Fichte",
    source_paths = file.path(ro_base_path, "Rotenfels_Fichte_DeltaT_neu/backup.dat"))

xml_addSensorMapping(
    xml_logger = ro_fi_delta,
    pattern = "^K([0-9]{2})?(?!R)$",
    replacement = "X\\1")
xml_addSensorMapping(
    xml_logger = ro_fi_delta,
    pattern = "^KR([0-9]{2})?$",
    replacement = "Y\\1")
xml_addSensorMapping(
    xml_logger = ro_fi_delta,
    pattern = "^L([0-9]{2})?$",
    replacement = "Z\\1")
xml_addSensorMapping(
    xml_logger = ro_fi_delta,
    pattern = "^([XYZ])$",
    replacement = "PR_\\1")
xml_addSensorMapping(
    xml_logger = ro_fi_delta,
    pattern = "^([XYZ])([0-9]{2})$",
    replacement = "\\2_FDR_\\1")
xml2::xml_add_child(ro_plot, ro_fi_delta)

#ro.deltaT.fi.alt.path <- "O:/PROJEKT/NIEDER/LOGGER/ROTENFEL/Rotenfels_Fichte_DeltaT_alt/backup.dat"
#ro.deltaT.fi.alt <- new("DeltaT", name = "DeltaT_alt", paths = ro.deltaT.fi.alt.path)
#ro.plot <- addLogger(ro.plot, ro.deltaT.fi.alt, "Fichte")

# Envilog
ro_fi_envilog <- xml_createLogger(
    type = "Envilog",
    sub_plot = "Fichte",
    source_paths = file.path(ro_base_path, "Rotenfels_Fichte_Envilog"))
xml2::xml_add_child(ro_plot, ro_fi_envilog)

# Freiland
ro_frei_adlm <- xml_createLogger(
    type = "ADLM",
    sub_plot = "Freiland",
    source_paths = file.path(ro_base_path, "Rotenfels_1/CSV"))

xml_addSensorMapping(
    xml_logger = ro_frei_adlm,
    pattern = "^Hygro.S3.Temperatur$",
    replacement = "AT")
xml_addSensorMapping(
    xml_logger = ro_frei_adlm,
    pattern = "^Niederschlag$",
    replacement = "PR")
xml_addSensorMapping(
    xml_logger = ro_frei_adlm,
    pattern = "^Hygro.S3.r.Feuchte$",
    replacement = "RH")
xml_addSensorMapping(
    xml_logger = ro_frei_adlm,
    pattern = "^SP.Lite2?.Pyranometer$",
    replacement = "SR")
xml_addSensorMapping(
    xml_logger = ro_frei_adlm,
    pattern = "^Windgeschwindigkeit$",
    replacement = "WS")
xml_addSensorMapping(
    xml_logger = ro_frei_adlm,
    pattern = "^Windrichtung$",
    replacement = "WD")
xml2::xml_add_child(ro_plot, ro_frei_adlm)
xml2::write_xml(ro_plot, "/home/polarfalke/Data/Temp/level2/rotenfels_setup.xml")


