co_plot <- xml_createPlot(
    plot_name = "Conventwald",
    screened_data_path = "O:/PROJEKT/NIEDER/LOGGER/Convent/Conventwald_gesamt_Korrektur")

# Buche
# AccessDB
co_bu_access <- xml_createLogger(
    type = "AccessDB",
    sub_plot = "Buche",
    source_paths = "O:/PROJEKT/CONVENT/LOGDATEN/DBDAT/Conventwald.mdb",
    db_table_name = "DL6_BBU5",
    date_column = "Dat_Zeit")

xml_addSensorMapping(
    xml_logger = co_bu_access,
    pattern = "^Regen",
    replacement = "PR_")
xml_addSensorMapping(
    xml_logger = co_bu_access,
    pattern = "^Se",
    replacement = "SE")
xml_addSensorMapping(
    xml_logger = co_bu_access,
    pattern = "^bbu5stam$",
    replacement = "Stammabfluss")
xml_addSensorMapping(
    xml_logger = co_bu_access,
    pattern = "^FDR([0-9]{2})([xyz])$",
    replacement = "\\1_FDR_\\2")
xml_addSensorMapping(
    xml_logger = co_bu_access,
    pattern = "^PF([0-9]{2})([xyz])$",
    replacement = "\\1_PF_mV_\\2")
xml_addSensorMapping(
    xml_logger = co_bu_access,
    pattern = "_x$",
    replacement = "_X")
xml_addSensorMapping(
    xml_logger = co_bu_access,
    pattern = "_y$",
    replacement = "_Y")
xml_addSensorMapping(
    xml_logger = co_bu_access,
    pattern = "_z$",
    replacement = "_Z")
xml2::xml_add_child(co_plot, co_bu_access)

# Fichte
# Envilog
co_fi_envilog <- xml_createLogger(
    type = "Envilog",
    sub_plot = "Fichte",
    source_paths =
        c("O:/PROJEKT/CONVENT/LOGDATEN/ROHDAT/DL4-WFI4/wfi4_pF_meter_csv",
          "O:/PROJEKT/NIEDER/LOGGER/Convent/Co_Fi_envilog/Rohdata"))
xml2::xml_add_child(co_plot, co_fi_envilog)

# ADLM
co_fi_adlm <- xml_createLogger(
    type = "ADLM",
    sub_plot = "Fichte",
    source_paths = "O:/PROJEKT/NIEDER/LOGGER/Convent/Convent_Fi_ADLM/csv")

xml_addSensorMapping(
    xml_logger = co_fi_adlm,
    pattern = "\\.Theta\\.",
    replacement = "_FDR_")
xml_addSensorMapping(
    xml_logger = co_fi_adlm,
    pattern = "(?<=_FDR_)K$",
    replacement = "X")
xml_addSensorMapping(
    xml_logger = co_fi_adlm,
    pattern = "(?<=_FDR_)L$",
    replacement = "Z")
xml_addSensorMapping(
    xml_logger = co_fi_adlm,
    pattern = "^Regen",
    replacement = "PR_")
xml2::xml_add_child(co_plot, co_fi_adlm)

# Freiland
co_frei_adlm <- xml_createLogger(
    type = "ADLM",
    sub_plot = "Freiland",
    source_paths = "O:/PROJEKT/NIEDER/LOGGER/Convent/Convent_ADLM_Turm/csv")

xml_addSensorMapping(
    xml_logger = co_frei_adlm,
    pattern = "^Hygro\\.S3\\.Temperatur$",
    replacement = "AT")
xml_addSensorMapping(
    xml_logger = co_frei_adlm,
    pattern = "^Hygro\\.S3\\.r\\.Feuchte$",
    replacement = "RH")
xml_addSensorMapping(
    xml_logger = co_frei_adlm,
    pattern = "^Niederschlag$",
    replacement = "PR")
xml_addSensorMapping(
    xml_logger = co_frei_adlm,
    pattern = "^SP\\.Lite2?\\.Pyranometer$",
    replacement = "SR")
xml_addSensorMapping(
    xml_logger = co_frei_adlm,
    pattern = "^Windgeschwindigkeit$",
    replacement = "WS")
xml_addSensorMapping(
    xml_logger = co_frei_adlm,
    pattern = "^Windrichtung",
    replacement = "WD")
xml2::xml_add_child(co_plot, co_frei_adlm)
xml2::write_xml(co_plot, "inst/extdata/plot_xml/conventwald_setup.xml")
