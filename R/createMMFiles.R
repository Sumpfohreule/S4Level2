createMMFiles <- function(xlsx.file, sheets = c("Fichte", "Buche", "Freiland"), map_function = identity) {
    plot.name <- xlsx.file %>%
        basename() %>%
        stringr::str_match(pattern = "^[[:alpha:]]*(?=_)") %>%
        as.character()

    # Import "Gesamt" tables for all sub plots
    final_full_join <- sheets %>%
        purrr::map(~ {
            MyUtilities::importAggregateExcelSheet(xlsx.file, .x) %>%
                mutate(SubPlot = .x)
        }) %>%
        purrr::map(~ tidyr::pivot_longer(.x, cols = !(Datum | SubPlot), names_to = "variable")) %>%
        bind_rows() %>%
        mutate(across(SubPlot, as.factor)) %>%
        map_function() %>%
        .importMMData(plot.name, sheets)

    mem_final_table <- final_full_join %>%
        mutate(date_observation = as.Date(Datum)) %>%
        select(-Datum) %>%
        group_by(plot, instrument_seq_nr, date_observation) %>%
        summarise(variable = unique(variable),
                  min = if_else(variable %in% c("AT", "RH", "ST", "MP", "WC"),
                                true = MyUtilities::min_with_default(value),
                                false = as.numeric(NA)),
                  max = if_else(variable %in% c("AT", "RH", "WS", "ST", "MP", "WC"),
                                true = MyUtilities::max_with_default(value),
                                false = as.numeric(NA)),
                  mean_sum = if_else(variable %in% c("AT", "RH", "WS", "SR", "UR", "ST", "MP", "WC"),
                                     true = MyUtilities::mean_with_default(value),
                                     false = MyUtilities::sum_with_default(value)),
                  completeness = round(sum(!is.na(value)) * 100 / length(value), digits = 0),
                  origin = 1,
                  status = 2,
                  other_observations = unique(other_observations)) %>%
        filter(any(!is.na(mean_sum))) %>%
        filter(any(!is.na(instrument_seq_nr))) %>%
        ungroup() %>%
        mutate(Sequence = 1:n()) %>%
        mutate(across(date_observation, ~ format(.x, "%d%m%y"))) %>%
        mutate(across(origin | status, ~ if_else(completeness == 0,
                                                 true = 9,
                                                 false = .x))) %>%
        mutate(across(mean_sum | min | max, round, digits = 2)) %>%
        relocate(S4Level2::MEM_FIELDS) %>%
        rename(`!Sequence` = Sequence)



    data_year <- stringr::str_match(xlsx.file, "(?<=/)[0-9]{4}(?=/)") %>%
        as.character()

    output.file.path <- file.path("data", "output", plot.name)
    dir.create(output.file.path, showWarnings = FALSE)
    mem.file <- file.path(output.file.path, paste0(plot.name, "_", data_year, ".MEM"))
    write.table(mem_final_table,
                file = mem.file,
                quote = FALSE,
                sep = ";",
                dec = ".",
                row.names = FALSE,
                na = "",
                fileEncoding = "UTF-8")
    print(paste0("Created ", mem.file))

    plm_final_table <- mem_final_table %>%
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

    plm.file <- file.path(output.file.path, paste0(plot.name, "_", data_year, ".PLM"))
    write.table(plm_final_table,
                file = plm.file,
                quote = FALSE,
                sep = ";",
                dec = ".",
                row.names = FALSE,
                na = "",
                fileEncoding = "UTF-8")
    print(paste0("Created ", plm.file))
}


.importMMData <- function(full_table, plot.name, sheets) {
    # Import template for consistent instrument numbers
    instrument_template <- .importPlmTemplateFile()

    # Separate variable (sensor) names into vertical_position, variable and profile_pit
    meo_table <- full_table %>%
        filter(stringr::str_detect(variable, "[0-9]{2}_(PF|FDR|T_PF)_[XYZ]")) %>%
        tidyr::separate(col = "variable",
                        into = c("vertical_position", "variable", "profile_pit"),
                        sep = "(?<!T)_(?!mV)",
                        extra = "drop",
                        fill = "left") %>%
        mutate(vertical_position = as.numeric(vertical_position) / -100) %>%
        mutate(variable = stringr::str_replace(variable, pattern = "^T_PF$", replacement = "ST")) %>%
        mutate(variable = stringr::str_replace(variable, pattern = "^PF$", replacement = "MP")) %>%
        mutate(variable = stringr::str_replace(variable, pattern = "^FDR$", replacement = "WC")) %>%
        mutate(value = if_else(variable == "MP", true = value / 10, false = value)) %>%
        nest_by(SubPlot) %>%
        mutate(plot = getEuPlotId(plot.name, SubPlot)) %>%
        tidyr::unnest(cols = data) %>%
        mutate(across(!(Datum | value), as.factor)) %>%
        left_join(instrument_template, c("plot", "variable", "vertical_position", "profile_pit"))

    mem_base_table <- full_table %>%
        filter(variable %in% c("AT", "RH", "WS", "WD", "SR", "PR"))
    final_full_join <- sheets %>%
        purrr::discard(~ .x == "Freiland") %>%
        purrr::map(~ {
            mem_base_table %>%
                mutate(plot = getEuPlotId(plot.name, .x))
        }) %>%
        bind_rows() %>%
        mutate(plot = as.factor(plot)) %>%
        left_join(instrument_template, by = c("plot", "variable")) %>%
        bind_rows(meo_table) %>%
        data.table()
    setkey(final_full_join, SubPlot, variable, vertical_position, profile_pit)
    final_full_join
}

.importPlmTemplateFile <- function() {
    template_file <- system.file("extdata", "042013_template.PLM", package = "S4Level2", mustWork = TRUE)
    template_col_names <- template_file %>%
        readr::read_delim(
            delim = ",",
            col_names = FALSE,
            col_types = readr::cols(),
            trim_ws = TRUE,
            n_max = 1,
            guess_max = 1) %>%
        unlist()
    template_col_names[1] <- "Sequence"
    template_col_names[4] <- "instrument_seq_nr"
    instrument_template <- template_file %>%
        readr::read_fwf(
            col_positions = readr::fwf_widths(c(4, 3, 5, 4, 2, 8, 8, 3, 3, 7, 3, 4, 5, 6, 7, 7, 4, 13, NA)),
            col_types = readr::cols(X2 = "i", X3 = "f", X6 = "c", X7 = "c", X10 = "c"),
            skip = 1)
    names(instrument_template) <- template_col_names

    instrument_template %>%
        mutate(SW_pit = profile_pit) %>%
        mutate(profile_pit = stringr::str_match(profile_pit, pattern = "[XYZ]$")) %>%
        mutate(profile_pit = as.factor(profile_pit))
}
