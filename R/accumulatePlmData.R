accumulatePlmData <- function(output_folder) {
    basename(output_folder) %>%
        paste0("^[[:alpha:]/]+_", ., "\\.PLM") %>%
        dir(output_folder, pattern = ., full.names = TRUE, recursive = TRUE) %>%
        purrr::walk(~ assertthat::assert_that(assertthat::not_empty(.x))) %>%
        purrr::map(~ readr::read_delim(
            file = .x,
            delim = ";",
            col_types = readr::cols(
                latitude = "c",
                longitude = "c",
                vertical_position = "c",
                date_monitoring_first = "c",
                date_monitoring_last = "c"))) %>%
        bind_rows() %>%
        arrange(plot, instrument_seq_nr) %>%
        mutate(`!Sequence` = 1:n())
}