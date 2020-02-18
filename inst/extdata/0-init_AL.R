al_plot <- xml_createPlot("Altensteig", "O:/PROJEKT/NIEDER/LOGGER/ALTENST/AT_ges_Korrektur")
al_frei_adlm <- xml_createLogger(
    type = "ADLM",
    sub_plot = "Freiland",
    source_paths = "O:/PROJEKT/NIEDER/LOGGER/ALTENST/Altensteig_1/CSV")
al_bu_adlm <- xml_createLogger(
    type = "ADLM",
    sub_plot = "Buche",
    source_paths = "O:/PROJEKT/NIEDER/LOGGER/ALTENST/Altensteig_BU_1/CSV")
al_fi_adlm <- xml_createLogger(
    type = "ADLM",
    sub_plot = "Fichte",
    source_paths = "O:/PROJEKT/NIEDER/LOGGER/ALTENST/Altensteig_Fi_1/CSV")

xml_addSensorMapping(al_frei_adlm,
                     pattern = "_?.AL.(FI|BU)",
                     replacement = "")
xml_addSensorMapping(al_frei_adlm,
                     pattern = "Hygro.S3.Temperatur",
                     replacement = "AT")
xml_addSensorMapping(al_frei_adlm,
                     pattern = "Niederschlag",
                     replacement = "PR")
xml_addSensorMapping(al_frei_adlm,
                     pattern = "Hygro.S3.r.Feuchte",
                     replacement = "RH")
xml_addSensorMapping(al_frei_adlm,
                     pattern = "Windgeschwindigkeit",
                     replacement = "WS")
xml_addSensorMapping(al_frei_adlm,
                     pattern = "Windrichtung",
                     replacement = "WD")
xml_addSensorMapping(al_frei_adlm,
                     pattern = "SP.Lite2.Pyranometer",
                     replacement = "SR")
xml2::xml_add_child(al_plot, al_frei_adlm)


xml_addSensorMapping(al_bu_adlm,
                     pattern = "_?.AL.(FI|BU)",
                     replacement = "")
xml_addSensorMapping(al_bu_adlm,
                     pattern = "PF_([0-9]{2})\\.([LK]R?)",
                     replacement = "\\1_MP_\\2")
xml_addSensorMapping(al_bu_adlm,
                     pattern = "PF_([0-9]{2})([LK]R?)\\.Temp",
                     replacement = "\\1_T_PF_\\2")
xml_addSensorMapping(al_bu_adlm,
                     pattern = "([0-9]{2})([LK]R?)\\.FDR",
                     replacement = "\\1_FDR_\\2")
xml_addSensorMapping(al_bu_adlm,
                     pattern = "^Stammab(fluss)*$",
                     replacement = "Stammabfluss")
xml_addSensorMapping(al_bu_adlm,
                     pattern = "^Regen",
                     replacement = "PR_")
xml_addSensorMapping(al_bu_adlm,
                     pattern = "_K$",
                     replacement = "_X")
xml_addSensorMapping(al_bu_adlm,
                     pattern = "_KR$",
                     replacement = "_Y")
xml_addSensorMapping(al_bu_adlm,
                     pattern = "_L$",
                     replacement = "_Z")
xml2::xml_add_child(al_plot, al_bu_adlm)


xml_addSensorMapping(al_fi_adlm,
                     pattern = "_?.AL.(FI|BU)",
                     replacement = "")
xml_addSensorMapping(al_fi_adlm,
                     pattern = "PF_([0-9]{2})\\.([LK]R?)",
                     replacement = "\\1_MP_\\2")
xml_addSensorMapping(al_fi_adlm,
                     pattern = "PF_([0-9]{2})([LK]R?)\\.Temp",
                     replacement = "\\1_T_PF_\\2")
xml_addSensorMapping(al_fi_adlm,
                     pattern = "([0-9]{2})([LK]R?)\\.FDR",
                     replacement = "\\1_FDR_\\2")
xml_addSensorMapping(al_fi_adlm,
                     pattern = "^Regen",
                     replacement = "PR_")
xml_addSensorMapping(al_fi_adlm,
                     pattern = "_K$",
                     replacement = "_X")
xml_addSensorMapping(al_fi_adlm,
                     pattern = "_KR$",
                     replacement = "_Y")
xml_addSensorMapping(al_fi_adlm,
                     pattern = "_L$",
                     replacement = "_Z")
xml_addSensorMapping(al_fi_adlm,
                     pattern = "^Temp_883$",
                     replacement = "Temp_037",
                     origin_date = "2013-06-05 12:30:00")
xml2::xml_add_child(al_plot, al_fi_adlm)
xml2::write_xml(al_plot, "inst/extdata/altensteig_setup.xml")


