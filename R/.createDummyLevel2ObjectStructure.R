.createDummyLevel2ObjectStructure <- function(uri_paths) {
    base <- new("Level2")
    base <- uri_paths %>%
        purrr::map(~ {
            split_uri <- stringr::str_split(.x, "/") %>%
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
                    uri = Level2URI(.x),
                    local_directory = "~/",
                    paths = "~/")
            }
            base
        })
    base
}