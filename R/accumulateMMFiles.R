########################################################################################################################
accumulateMMFiles <- function(target.year, output.folder) {
    mm_files <- target.year %>%
        paste0("^[[:alpha:]/]+_", .) %>%
        dir("data", pattern = ., full.names = TRUE, recursive = TRUE)
    assertthat::assert_that(assertthat::not_empty(mm_files))

    column_types <- readr::cols(
        latitude = "c",
        longitude = "c",
        vertical_position = "c",
        date_monitoring_first = "c",
        date_monitoring_last = "c")
    mm_files %>%
        purrr::keep(~ stringr::str_detect(.x, pattern = "\\.PLM")) %>%
        purrr::map(~ readr::read_delim(
            file = .x,
            delim = ";",
            col_types = column_types)) %>%
        bind_rows() %>%
        arrange(plot, instrument_seq_nr) %>%
        mutate(`!Sequence` = 1:n()) %>%
        readr::write_delim(
            path =file.path(output.folder, paste0("04", target.year, ".PLM")),
            delim = ";",
            na = "",
            quote_escape = FALSE)
    print(sprintf("Created PLM file in '%s'", output.folder))

    mm_files %>%
        purrr::keep(~ stringr::str_detect(.x, pattern = "\\.MEM")) %>%
        purrr::map(~ readr::read_delim(
            file = .x,
            delim = ";",
            col_types = readr::cols())) %>%
        bind_rows() %>%
        arrange(plot, instrument_seq_nr) %>%
        mutate(`!Sequence` = 1:n()) %>%
        readr::write_delim(
            path = file.path(output.folder, paste0("04", target.year, ".MEM")),
            delim = ";",
            na = "")
    print(sprintf("Created MEM file in '%s'", output.folder))
}
