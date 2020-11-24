selected_year <- 2019
# output_path <- "/home/polarfalke/Data/Nextcloud_FVA/ICP-Forests/MM/"
output_path <- file.path("W:/Nextcloud/ICP-Forests/MM", selected_year)

createMMFiles(level2, "Altensteig", selected_year, output_path)
level2 %>% getMMSourcePath("Conventwald", selected_year) %>%
    createMemBaseTable() %>%
    mutate(value = if_else(variable == "SR" & value < 0, true = 0, false = value)) %>%
    aggregateMemTable() %>%
    mutate(other_observations = if_else(variable == "WS" & mean_sum == 0, true = "Sensor is probably frozen", false = "")) %>%
    writeMMFile(file_path = sprintf("%s/%s_%d.MEM", output_path, "Conventwald", selected_year), return = TRUE) %>%
    createPlmTable() %>%
    writeMMFile(sprintf("%s/%s_%d.PLM", output_path, "Conventwald", selected_year))
createMMFiles(level2, "Esslingen", selected_year, output_path)
createMMFiles(level2, "Heidelberg", selected_year, output_path)
createMMFiles(level2, "Ochsenhausen", selected_year,output_path)
createMMFiles(level2, "Rotenfels", selected_year, output_path, sheets = c("Fichte", "Freiland"))

accumulateMMFiles(output_path)


mem_source_path <- getMMSourcePath(level2_object, plot_name, selected_year)








dt <- readr::read_delim("/home/polarfalke/Data/Nextcloud_FVA/Projekte/R/S4Level2/data/output/Esslingen/Esslingen_2019 (copy 1).MEM",
                  delim = ";",
                  na = "")
dt %>%
    arrange(plot, instrument_seq_nr, variable, lubridate::dmy(date_observation)) %>%
    mutate(`!Sequence` = 1:n()) %>%
    readr::write_delim("/home/polarfalke/Data/Nextcloud_FVA/Projekte/R/S4Level2/data/output/Esslingen/Esslingen_2019 (copy 2).MEM",
                       delim = ";",
                       na = "")
