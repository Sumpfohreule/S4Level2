.createDummyLevel2ObjectStructure <- function(uri_paths) {
    base <- new("Level2")
    for (path in uri_paths) {
        split_uri <- stringr::str_split(path, "/") %>%
            unlist()
        existing_plots <- base %>%
            getPlotList() %>%
            names()
        if (!(split_uri[1] %in% existing_plots)) {
            plot <- new("Plot")
            plot@Name <- split_uri[1]
            plot@Level2URI <- Level2URI(split_uri[1])
            base@Plots[[split_uri[1]]] <- plot
        }

        plot_names <- getPlotList(base) %>% names()
        existing_sub_plots <- base %>%
            getPlotList() %>%
            purrr::keep(~ getName(.x) == split_uri[1]) %>%
            purrr::map(~ getSubPlotList(.x)) %>%
            unlist() %>%
            purrr::map(~ getName(.x)) %>%
            unlist()
        if (!(split_uri[2] %in% existing_sub_plots)) {
            new_subplot <- new("SubPlot")
            new_subplot@Name <- split_uri[2]
            new_subplot@Level2URI <- Level2URI(split_uri[1], split_uri[2])
            base@Plots[[split_uri[1]]]@SubPlots[[split_uri[2]]] <- new_subplot
        }
        existing_loggers <- base %>%
            getPlotList() %>%
            purrr::keep(~ getName(.x) == split_uri[1]) %>%
            purrr::map(~ getSubPlotList(.x)) %>%
            purrr::flatten() %>%
            purrr::keep(~ getName(.x) == split_uri[2]) %>%
            purrr::map(~ getDataStructureList(.x)) %>%
            purrr::flatten() %>%
            purrr::map(~ getName(.x))
        if (!(split_uri[3] %in% existing_loggers)) {
            base@Plots[[split_uri[1]]]@SubPlots[[split_uri[2]]]@Loggers[[split_uri[3]]] <- new(
                "ADLM",
                unique_name = split_uri[3],
                uri = Level2URI(path),
                local_directory = tempdir(),
                paths = tempdir())
        }
    }
    base
}
