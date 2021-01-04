.createDummyLevel2ObjectStructure <- function(uri_paths) {
    base <- new("Level2")
    for (path in uri_paths) {
        split_uri <- stringr::str_split(path, "/") %>%
            unlist()
        existing_plots <- base %>%
            getPlotList() %>%
            names()
        if (!(split_uri[1] %in% existing_plots)) {
            base@Plots[[split_uri[1]]] <- new("Plot")
        }

        existing_sub_plots <- base %>%
            getPlotList() %>%
            purrr::map(~ getSubPlotList(.x)) %>%
            unlist() %>%
            names()
        if (!(split_uri[2] %in% existing_sub_plots)) {
            base@Plots[[split_uri[1]]]@SubPlots[[split_uri[2]]] <- new("SubPlot")
        }
        existing_loggers <- base %>%
            getPlotList() %>%
            purrr::map(~ getSubPlotList(.x)) %>%
            purrr::flatten() %>%
            purrr::map(~ getDataStructureList(.x)) %>%
            unlist() %>%
            names()
        if (!(split_uri[3] %in% existing_sub_plots)) {
            base@Plots[[split_uri[1]]]@SubPlots[[split_uri[2]]]@Loggers[[split_uri[3]]] <- new(
                "ADLM",
                uri = Level2URI(path),
                local_directory = "~/",
                paths = "~/")
        }
    }
    base
}