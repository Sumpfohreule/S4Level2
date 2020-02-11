########################################################################################################################
loadDeltaTFullYear <- function(logger_path, selected_year) {
    logger_year_folders <- paste(logger_path, c(selected_year, selected_year + 1), sep = "/")
    target_year_file_paths <- dir(logger_year_folders[1], pattern = "\\.dat", full.names = TRUE)
    next_year_first_file_path <- dir(logger_year_folders[2], pattern = "\\.dat", full.names = TRUE)[1]
    all_file_paths <- c(target_year_file_paths, na.omit(next_year_first_file_path))
    
    deltaT_data_list <- list()
    for (single_file_path in all_file_paths) {
        temp_data <- readDeltaT(single_file_path)
        deltaT_data_list[[single_file_path]] <- temp_data %>%
            mutate(file_origin = basename(single_file_path))
    }
    full_deltaT_data <- data.table::rbindlist(deltaT_data_list, use.names = TRUE) %>%
        arrange(Datum)
    
    year_selection_data <- full_deltaT_data %>%
        filter(data.table::year(Datum) == selected_year) %>%
        arrange(Datum) %>%
        as.data.table() %>%
        unique(by = "Datum")
    
    filled_date_column <- year_selection_data %>%
        pull(Datum) %>%
        fillDateGaps() %>%
        data.frame(Datum = .)
    
    final_data_join <- year_selection_data %>%
        full_join(filled_date_column, by = "Datum") %>%
        arrange(Datum) %>%
        select(-file_origin)
    
    return(final_data_join)
}
