selected_year <- 2019
# output_path <- "/home/polarfalke/Data/Nextcloud_FVA/ICP-Forests/MM/"
output_path <- file.path("W:/Nextcloud/ICP-Forests/MM", selected_year)

createMMFiles(level2, "Altensteig", selected_year, output_path)
level2 %>% getMMSourcePath("Conventwald", selected_year) %>%
    createMemBaseTable() %>%
    mutate(value = if_else(variable == "SR" & value < 0, true = 0, false = value)) %>%
    aggregateMemTable() %>%
    writeMMFile(file_path = sprintf("%s/%s_%d.MEM", output_path, "Conventwald", selected_year), return = TRUE) %>%
    createPlmTable() %>%
    writeMMFile(sprintf("%s/%s_%d.PLM", output_path, "Conventwald", selected_year))
createMMFiles(level2, "Esslingen", selected_year, output_path)
createMMFiles(level2, "Heidelberg", selected_year, output_path)
createMMFiles(level2, "Ochsenhausen", selected_year,output_path)
createMMFiles(level2, "Rotenfels", selected_year, output_path, sheets = c("Fichte", "Freiland"))

accumulateMemData(output_path) %>%
    mutate(other_observations = if_else(
        variable == "WS" & mean_sum == 0,
        true = "Sensor was probably frozen",
        false = NA_character_)) %>%
    readr::write_delim(path = paste0(output_path, "/04", selected_year, ".MEM"),
                       delim = ";",
                       na = "")

accumulatePlmData(output_path) %>%
    readr::write_delim(path = paste0(output_path, "/04", selected_year, ".PLM"),
                       delim = ";",
                       na = "")
