createMMFiles <- function(level2_object, plot_name, selected_year, output_path, sheets = c("Fichte", "Buche", "Freiland")) {
    level2_object %>% getMMSourcePath(plot_name, selected_year) %>%
        createMemBaseTable(sheets = sheets) %>%
        aggregateMemTable() %>%
        writeMMFile(file_path = sprintf("%s/%s_%d.MEM", output_path, plot_name, selected_year), return = TRUE) %>%
        createPlmTable() %>%
        writeMMFile(sprintf("%s/%s_%d.PLM", output_path, plot_name, selected_year))
}

getMMSourcePath <- function(level2_object, plot_name, selected_year) {
    level2_object %>%
        getObjectByURI(Level2URI(plot_name)) %>%
        getCorrectedAggregatePath() %>%
        file.path(selected_year) %>%
        MyUtilities::getLastModifiedFile()
}

createMemBaseTable <- function(mem_source_path, sheets = c("Buche", "Fichte", "Freiland")) {
    plot_name <- mem_source_path %>%
        basename() %>%
        stringr::str_match(pattern = "^[[:alpha:]]+") %>%
        as.character()
    # Import raw data
    mem_source_data <- sheets %>%
        purrr::map(~ MyUtilities::importAggregateExcelSheet(mem_source_path, .x) %>%
                       mutate(SubPlot = .x)) %>%
        purrr::map(~ tidyr::pivot_longer(.x, cols = !(Datum | SubPlot), names_to = "variable")) %>%
        bind_rows()

    # Create MEM base table
    old_meo_converted <- mem_source_data %>%
        filter(stringr::str_detect(variable, "[0-9]{2}_(PF|FDR|T_PF)_[XYZ]")) %>%
        tidyr::separate(col = "variable",
                        into = c("vertical_position", "variable", "profile_pit"),
                        sep = "(?<!T)_(?!mV)",
                        extra = "drop",
                        fill = "left") %>%
        mutate(vertical_position = as.numeric(vertical_position) / -100) %>%
        mutate(across(vertical_position | variable | profile_pit, as.factor)) %>%
        mutate(variable = recode_factor(variable, T_PF = "ST", PF = "MP", FDR = "WC")) %>%
        mutate(value = if_else(variable == "MP", true = value / 10, false = value)) %>%
        nest_by(SubPlot) %>%
        mutate(plot = getEuPlotId(plot_name, SubPlot)) %>%
        tidyr::unnest(cols = data) %>%
        ungroup() %>%
        mutate(across(SubPlot | plot, as.factor)) %>%
        inner_join(S4Level2::PLM_TEMPLATE %>% mutate(profile_pit = as.character(stringr::str_match(SW_pit,"[XYZ]$"))),
                   by = c("plot", "variable", "profile_pit", "vertical_position"))
    mem_converted <- mem_source_data %>%
        filter(variable %in% MEM_SENSORS)
    output_table <- sheets %>%
        purrr::discard(~ .x == "Freiland") %>%
        purrr::map(~ {
            mem_converted %>%
                mutate(plot = getEuPlotId(plot_name, .x))
        }) %>%
        bind_rows() %>%
        mutate(plot = as.factor(plot)) %>%
        inner_join(S4Level2::PLM_TEMPLATE, by = c("plot", "variable")) %>%
        bind_rows(old_meo_converted) %>%
        arrange(plot, SubPlot, variable, profile_pit, -as.numeric(vertical_position), Datum)
    return(output_table)
}

# Aggregate MEM base table and join missing columns
aggregateMemTable <- function(mem_base_table) {
    output_table <- mem_base_table %>%
        mutate(date_observation = as.Date(Datum)) %>%
        select(-Datum) %>%
        group_by(plot, variable, instrument_seq_nr, date_observation) %>%
        # group_by(plot, variable, profile_pit, vertical_position, date_observation) %>%
        summarise(variable = unique(variable),
                  min = if_else(variable %in% S4Level2::MM_MIN_SENSORS,
                                true = MyUtilities::min_with_default(value),
                                false = as.numeric(NA)),
                  max = if_else(variable %in% S4Level2::MM_MAX_SENSORS,
                                true = MyUtilities::max_with_default(value),
                                false = as.numeric(NA)),
                  mean_sum = if_else(variable %in% S4Level2::MM_MEAN_SENSORS,
                                     true = MyUtilities::mean_with_default(value),
                                     false = MyUtilities::sum_with_default(value)),
                  completeness = round(sum(!is.na(value)) * 100 / length(value), digits = 0),
                  origin = 1,
                  status = 2,
                  other_observations = unique(other_observations)) %>%
        filter(!all(is.na(mean_sum))) %>%
        ungroup() %>%
        arrange(plot, instrument_seq_nr, variable, date_observation) %>%
        mutate(Sequence = 1:n()) %>%
        mutate(across(date_observation, ~ format(.x, "%d%m%y"))) %>%
        mutate(across(origin | status, ~ if_else(completeness == 0,
                                                 true = 9,
                                                 false = .x))) %>%
        mutate(across(mean_sum | min | max, round, digits = 2)) %>%
        relocate(S4Level2::MEM_FIELDS) %>%
        rename(`!Sequence` = Sequence)
}

# Save
writeMMFile <- function(mm_data, file_path, return = FALSE) {
    dir.create(dirname(file_path), showWarnings = FALSE)
    write.table(mm_data,
                file = file_path,
                quote = FALSE,
                sep = ";",
                dec = ".",
                row.names = FALSE,
                na = "",
                fileEncoding = "UTF-8")
    print(paste0("Created ", file_path))
    if (isTRUE(return)) {
        return(mm_data)
    }
}

createPlmTable <- function(mem_table) {
    plm_output_table <- mem_table %>%
        filter(!is.na(mean_sum)) %>%
        group_by(plot, instrument_seq_nr, variable) %>%
        mutate(across(date_observation, lubridate::dmy)) %>%
        summarise(
            date_monitoring_first = min(date_observation),
            date_monitoring_last = max(date_observation)) %>%
        mutate(measuring_days = date_monitoring_last - date_monitoring_first + 1) %>%
        mutate(across(date_monitoring_first | date_monitoring_last, ~ format(.x, "%d%m%y"))) %>%
        mutate(across(measuring_days, as.numeric)) %>%
        inner_join(S4Level2::PLM_TEMPLATE, by = c("plot", "instrument_seq_nr", "variable")) %>%
        filter(!is.na(date_monitoring_first)) %>%
        ungroup() %>%
        mutate(Sequence = 1:n()) %>%
        relocate(S4Level2::PLM_FIELDS) %>%
        rename(`!Sequence` = Sequence)
    return(plm_output_table)
}
